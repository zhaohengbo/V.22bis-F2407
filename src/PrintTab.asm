	.def	_CLI0, _CLI1, _CLI2, _CLI3, _CLI4, _CLI5, _CLI6, _CLI7
	.def	_OK, _NoCarrier, _Error, _Connect1200, _Connect2400
	.def	_CidRing, _CidDT
	.def	_NoDial, _Busy, _V22BIS, _V22, _CONNECT
	.def	_V21, _V23
	.def	_CON1275, _CON7512

		   
_CLI0
	.string		"DATE/TIME:"
	.word		0000h

_CLI1
	.string		"Tel.:"
	.word		0000h

_CLI2
	.string		"FCLIP:"
	.word		0000h

_CLI3
	.string		"No CLIP:"
	.word		0000h

_CLI4
	.string		"Name:"
	.word		0000h

_CLI5
	.string		"No Name:"
	.word		0000h

_CLI6
	.string		"Call Type:"
	.word		0000h

_CLI7
	.string		"FCLIP Type:"
	.word		0000h

_OK
	.string		"OK"
	.word		0000h

_NoCarrier
	.string		"NO CARRIER"
	.word		0000h

_Error
	.string		"ERROR"
	.word		0000h

_Connect1200
	.string		"CONNECT 1200"
	.word		0000h

_Connect2400
	.string		"CONNECT 2400"
	.word		0000h

_CidRing
	.string		"CID with RP_AS"
	.word		0000h

_CidDT
	.string		"CID with DT_AS"
	.word		0000h

_NoDial
	.string		"NO DIALTONE"
	.word		0000h

_Busy
	.string		"BUSY"
	.word		0000h

_V22BIS
	.string		"V22bis"
	.word		0000h

_V22
	.string		"V22"
	.word		0000h

_V21
	.string		"V21"
	.word		0000h

_V23
	.string		"V23"
	.word		0000h

_CONNECT
	.string		"CONNECT"
	.word		0000h

_CON1275
	.string		"CONNECT 1200/75"
	.word		0000h

_CON7512
	.string		"CONNECT 75/1200"
	.word		0000h
