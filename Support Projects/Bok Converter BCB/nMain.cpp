//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "nMain.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
	query->SQL->Add("SELECT * FROM Main");
	query->Open();
	query->Active = true;
	Variant bkId = query->FieldValues["BkId"];

	query->Active = false;
	query->SQL->Clear();

	UnicodeString s;
	s.sprintf("SELET FROM b%s", bkId);

	query->SQL->Add(s);
	query->Open();
	query->Active = true;

	DBMemo1->DataField = "nass";

}
//---------------------------------------------------------------------------
