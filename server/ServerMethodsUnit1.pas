unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, frxClass, frxExportPDF, frxDBSet;

type
  TServerMethods1 = class(TDSServerModule)
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxPDFExport1: TfrxPDFExport;
    fdConn: TFDConnection;
    qryClientes: TFDQuery;
    qryClientesCUST_NO: TIntegerField;
    qryClientesCUSTOMER: TStringField;
    qryClientesCONTACT_FIRST: TStringField;
    qryClientesCONTACT_LAST: TStringField;
    qryClientesPHONE_NO: TStringField;
    qryClientesADDRESS_LINE1: TStringField;
    qryClientesADDRESS_LINE2: TStringField;
    qryClientesCITY: TStringField;
    qryClientesSTATE_PROVINCE: TStringField;
    qryClientesCOUNTRY: TStringField;
    qryClientesPOSTAL_CODE: TStringField;
    qryClientesON_HOLD: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function DownloadFile(const AArquivo: String; out Size: Int64): TStream;
    function GerarPDF(out Size: Int64): TStream;
  end;

implementation


{$R *.dfm}


uses System.StrUtils;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.GerarPDF(out Size: Int64): TStream;
var
  CaminhoPDF : String;
  Debug      : String;
begin
  qryClientes.Active            := True;

  CaminhoPDF                    := 'C:\Temp\PDF\'; //;ExtractFilePath('..\..\..\PDF\');

  frxPDFExport1.FileName        := CaminhoPDF + 'Teste.pdf';
  frxPDFExport1.DefaultPath     := CaminhoPDF + '\';
  frxPDFExport1.ShowDialog      := False;
  frxPDFExport1.ShowProgress    := False;
  frxPDFExport1.OverwritePrompt := False;

  frxReport1.PrepareReport();
  frxReport1.Export(frxPDFExport1);
  qryClientes.Active            := False;

  Result := TFileStream.Create(CaminhoPDF + 'Teste.pdf', fmOpenRead or fmShareDenyNone);
  Size   := Result.Size;

  Result.Position := 0;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.DownloadFile(const AArquivo: String;
  out Size: Int64): TStream;
var
  CaminhoImagem: String;
  Debug: String;
begin
  CaminhoImagem := ExtractFilePath('..\..\..\img\');
  Debug := CaminhoImagem + AArquivo;
  Result := TFileStream.Create(CaminhoImagem + AArquivo, fmOpenRead or fmShareDenyNone);
  Size   := Result.Size;

  Result.Position := 0;
end;

end.

