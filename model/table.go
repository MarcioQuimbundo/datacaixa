package model

type Table struct {
	HotelId        int64  `json:"-,hotel,omitempty"`
	PDVId          int64  `json:"-,pdv,omitempty"`
	TableId        int64  `json:"-,mesa,omitempty"`
	Number         int64  `json:"numero,omitempty"`
	Status         string `json:"situacao,omitempty"`
	BirthdayPerson string `json:"aniveriante,omitempty"`
	VIP            string `json:"vip,omitempty"`
	Honeymoon      string `json:"lua_mel,omitempty"`
	PVD            string `json:"pvd,omitempty"`
	Seats          string `json:"lugares,omitempty"`
}
