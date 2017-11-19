package secql

type Company struct {
	CIK    string
	Name   string
	Symbol string
}

type CompanyService interface {
	Get(symbol string) (*Company, error)
	Create(company *Company) error
	Delete(symbol string) error
}
