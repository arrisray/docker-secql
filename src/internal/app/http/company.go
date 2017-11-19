package http

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
	"github.com/go-chi/chi"
	"golang.org/x/net/html/charset"
	"io"
	"net/http"
)

type Address struct {
	City    string `xml:"city"`
	State   string `xml:"state"`
	Street  string `xml:"street"`
	Street2 string `xml:"street2,omitempty"`
	Zip     string `xml:"zipCode"`
	Phone   string `xml:"phoneNumber,omitempty"`
}

type CompanyInfo struct {
	CIK                  int     `xml:"CIK"`
	CIKHREF              string  `xml:"CIKHREF"`
	Location             string  `xml:"Location"`
	SIC                  int     `xml:"SIC"`
	SICDescription       string  `xml:"SICDescription"`
	SICHREF              string  `xml:"SICHREF"`
	FiscalYearEnd        string  `xml:"fiscalYearEnd"`
	Name                 string  `xml:"name"`
	StateOfIncorporation string  `xml:"stateOfIncorporation"`
	BusinessAddress      Address `xml:"businessAddress"`
	MailingAddress       Address `xml:"mailingAddress"`
}

type CompanyFilings struct {
	XMLName     struct{}    `xml:"companyFilings" json:"-"`
	CompanyInfo CompanyInfo `xml:"companyInfo"`
}

func (h *Handler) getCompany(w http.ResponseWriter, r *http.Request) {
	symbol := chi.URLParam(r, "id")
	url := fmt.Sprintf("https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=%s&type=&dateb=&owner=exclude&count=100&output=xml", symbol)
	response, _ := http.Get(url)
	defer response.Body.Close()

	filings, _ := parseCompanyFilings(response.Body)
	out, _ := json.MarshalIndent(filings, "", "  ")

	w.Header().Set("Content-Type", "text/json")
	w.Write([]byte(out))
}

func parseCompanyFilings(data io.ReadCloser) (*CompanyFilings, error) {
	var filings CompanyFilings
	decoder := xml.NewDecoder(data)
	decoder.CharsetReader = charset.NewReaderLabel
	err := decoder.Decode(&filings)
	if err != nil {
		return nil, err
	}
	return &filings, nil
}
