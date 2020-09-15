package main

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/md5"
	crand "crypto/rand"
	"crypto/sha256"
	"encoding/asn1"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"math/big"
	"net/http"
	"net/url"
	"os"
	"strconv"
	"time"

	"github.com/gorilla/websocket"
)

//结构定义开始----------------------------------------------------------------------------------------------------------------
type Package struct {
	CrossMerkleRoot []byte
	Height          int64
}
type CrossMessages struct {
	Txlist          []*TX
	Sig             []byte    //转出方所有节点对该交易包的merkle_root进行门限签名
	Pubkeys         []byte    //只有一把公钥
	CrossMerkleRoot []byte    //merkle root
	TreePath        [][]byte  //从该包的txlist生成的hash值到root的路径
	SrcZone         string    //发送方
	DesZone         string    //接收方
	Height          int64     //标志时刻
	Packages        []Package //应该回复删除什么包
	ConfirmPackSigs []byte    //对于这些包的签名
}
type TX struct {
	Txtype      string
	Sender      string
	Receiver    string
	ID          [sha256.Size]byte
	Content     string
	TxSignature string
	Operate     int

	// 当交易类型为relayTX时有用，其余类型为空跳过即可
	Height int // 记录该条跨片交易被共识的区块高度
}

type plist []*ecdsa.PrivateKey

//结构定义结束----------------------------------------------------------------------------------------------------------------
func createCount() plist {
	var pl plist
	priv, _ := ecdsa.GenerateKey(elliptic.P256(), crand.Reader)
	priv1, _ := ecdsa.GenerateKey(elliptic.P256(), crand.Reader)
	pl = append(pl, priv)
	pl = append(pl, priv1)
	return pl
}

type ecdsaSignature struct {
	X, Y *big.Int
}

func pub2string(pub ecdsa.PublicKey) string {

	coor := ecdsaSignature{X: pub.X, Y: pub.Y}
	b, _ := asn1.Marshal(coor)

	return hex.EncodeToString(b)
}
func bigint2str(r, s big.Int) string {
	coor := ecdsaSignature{X: &r, Y: &s}
	b, _ := asn1.Marshal(coor)
	return hex.EncodeToString(b)
}
func digest(Content string) []byte {
	origin := []byte(Content)

	// 生成md5 hash值
	digest_md5 := md5.New()
	digest_md5.Write(origin)

	return digest_md5.Sum(nil)
}
func createPrivContent(rate int, pl []*ecdsa.PrivateKey) (string, string) {
	tx_content := pub2string(pl[0].PublicKey) + "_" + pub2string(pl[1].PublicKey) + "_" + strconv.Itoa(rate) + "_" + strconv.FormatInt(time.Now().UnixNano(), 10)
	tr, ts, _ := ecdsa.Sign(crand.Reader, pl[0], digest(tx_content))
	sig := bigint2str(*tr, *ts)
	return tx_content, sig
}
func connect(host string) (*websocket.Conn, *http.Response, error) {
	u := url.URL{Scheme: "ws", Host: host, Path: "/websocket"}
	return websocket.DefaultDialer.Dial(u.String(), nil)
}

type RPCRequest struct {
	JSONRPC  string          `json:"jsonrpc"`
	Sender   string          `json:"Sender"`   //添加发送者
	Receiver string          `json:"Receiver"` //添加接受者
	Flag     int             `json:"Flag"`
	ID       jsonrpcid       `json:"id"`
	Method   string          `json:"method"`
	Params   json.RawMessage `json:"params"` // must be map[string]interface{} or []interface{}

}
type jsonrpcid interface {
	isJSONRPCID()
}
type JSONRPCStringID string

func (JSONRPCStringID) isJSONRPCID() {}

func createTx(rate int, relay bool) *TX {
	pl := createCount()
	content, sig := createPrivContent(rate, pl)
	var txtype string
	if relay {
		txtype = "relaytx"
	} else {
		txtype = "addtx"
	}
	tx := &TX{
		Txtype:      txtype,
		ID:          sha256.Sum256([]byte(content)),
		Content:     content,
		TxSignature: sig,
		Operate:     1}
	return tx
}
func createCrossMessage() []byte {
	//模拟出一个交易包，包含100条交易
	var txlist []*TX
	for i := 0; i < 100; i++ {
		var t *TX
		if i%2 == 0 {
			//生成relay_in交易
			t = createTx(100, true)
		} else {
			//生成relay_out交易
			t = createTx(100, false)
		}
		txlist = append(txlist, t)
	}

	cm := &CrossMessages{
		Txlist:          txlist,
		Sig:             nil,
		Pubkeys:         nil,
		CrossMerkleRoot: []byte("hello"),
		TreePath:        nil,
		SrcZone:         "1",
		DesZone:         "0",
		Height:          2,
	}
	data, _ := json.Marshal(cm)
	return data
}
func SendCrossMessage(ip string) {
	var c *websocket.Conn
	var cm []byte
	var err error
	c, _, err = connect(ip)
	if err != nil {
		fmt.Println("链接失败")
	}
	cm = createCrossMessage()
	paramsJSON, err := json.Marshal(map[string]interface{}{"tx": cm})
	rawParamsJSON := json.RawMessage(paramsJSON)
	err = c.WriteJSON(RPCRequest{
		JSONRPC: "2.0",
		ID:      JSONRPCStringID("CrossMessageTest"),
		Method:  "broadcast_tx_async",
		Params:  rawParamsJSON,
	})
	if err != nil {
		fmt.Println("发送失败")
	}
	c.Close()
}
func main() {
	args := os.Args
	ip := args[1]
	SendCrossMessage(ip) //发送交易
	//SendTx(ip, rateint, isrelay)
}
