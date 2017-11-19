package mysql

import (
	"database/sql"
	"github.com/arrisray/secql/internal/app"
	_ "github.com/go-sql-driver/mysql"
)

type CompanyService struct {
	DB *sql.DB
}

func (service *CompanyService) Get(symbol string) (*secql.Company, error) {
	return nil, nil
}

func (service *CompanyService) Create(company *secql.Company) error {
	return nil
}

func (service *CompanyService) Delete(symbol string) error {
	return nil
}
