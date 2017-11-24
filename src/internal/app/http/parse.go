package http

import (
	"bytes"
	"encoding/json"
	"encoding/xml"
	"fmt"
	"golang.org/x/net/html/charset"
	"net/http"
	"os"
)

type Context struct {
	XMLName xml.Name `xml:"context"`
	Id      string   `xml:"id,attr"`
	Entity  struct {
		Identifier struct {
			Scheme string `xml:"scheme,attr"`
			Value  string `xml:",innerxml"`
		} `xml:"identifier" json:"identifier"`
		Segment struct {
			ExplicitMember struct {
				Dimension string `xml:"dimension,attr"`
				Value     string `xml:",innerxml"`
			} `xml:"explicitMember" json:"explicitMember"`
		} `xml:"segment,omitempty" json:"segment"`
	} `xml:"entity" json:"entity"`
	Period struct {
		Instant   string `xml:"instant,omitempty"`
		StartDate string `xml:"startDate,omitempty"`
		EndDate   string `xml:"endDate,omitempty"`
	} `xml:"period" json:"period"`
}

func (h *Handler) parse(w http.ResponseWriter, r *http.Request) {
	filepath := "./data/fb/10-k/20161231/fb-20161231.xml"
	handle, err := os.Open(filepath)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer handle.Close()

	decoder := xml.NewDecoder(handle)
	decoder.CharsetReader = charset.NewReaderLabel
	var buffer bytes.Buffer

	for {
		// Read tokens from the XML document in a stream.
		t, err := decoder.Token()
		if err != nil {
			fmt.Println(err)
			break
		}
		if t == nil {
			break
		}

		// Inspect the type of the token just read.
		switch se := t.(type) {
		case xml.StartElement:
			buffer.WriteString(se.Name.Space + ":" + se.Name.Local)
			for _, attr := range se.Attr {
				buffer.WriteString(", " + attr.Name.Space + ":" + attr.Name.Local + "=" + attr.Value)
			}
			buffer.WriteString("\n")
			if se.Name.Local == "context" {
				var context Context
				_ = decoder.DecodeElement(&context, &se)
				out, _ := json.MarshalIndent(context, "", "  ")
				buffer.WriteString(fmt.Sprintf("\n>>>\n%s\n<<<\n\n", out))
			}
		default:
		}
	}

	// Respond with parsed content
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte(buffer.String()))
}
