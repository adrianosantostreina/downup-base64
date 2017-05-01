unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  ClientModuleUnit1, FMX.Controls.Presentation, FMX.StdCtrls,

  System.IOUtils, FMX.Objects, FMX.ListBox, FMX.Layouts, FMX.TabControl;

type
  TForm1 = class(TForm)
    SpeedButton1: TSpeedButton;
    lblStatus: TLabel;
    lblMensagem: TLabel;
    Image1: TImage;
    ToolBar1: TToolBar;
    SpeedButton2: TSpeedButton;
    ToolBar2: TToolBar;
    Layout1: TLayout;
    Label1: TLabel;
    cbxImagens: TComboBox;
    Layout2: TLayout;
    pgbProgresso: TProgressBar;
    Layout3: TLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Button1: TButton;
    Layout4: TLayout;
    pgbProgressoPDF: TProgressBar;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses xPlat.OpenPDF;

procedure TForm1.Button1Click(Sender: TObject);
var
  RetStream  : TStream;
  Buffer     : PByte;
  Mem        : TMemoryStream;
  BytesRead  : Integer;
  DocumentId : Int64;
  Size       : Int64;
  Filename   : String;
  BufSize    : Integer;
  Destino    : String;
  QualImagem : String;
begin
  BufSize := 1024;
  try
    Mem := TMemoryStream.Create;
    GetMem(Buffer, BufSize);
    try
      FileName := 'Teste.pdf';
      RetStream := CM.ServerMethods1Client.GerarPDF(Size); //DownloadFile(FileName, Size);
      RetStream.Position := 0;
      if (Size <> 0) then
      begin
        pgbProgressoPDF.Max := Size;
        pgbProgressoPDF.Value := 0;
        FileName := 'Teste.pdf';
        repeat
          BytesRead := RetStream.Read(Pointer(Buffer)^, BufSize);
          if (BytesRead > 0) then
            Mem.WriteBuffer(Pointer(Buffer)^, BytesRead);

          lblStatus.Text := Format('Baixando %s de %s bytes', [IntToStr(Mem.Size), IntToStr(Size)]);
          pgbProgressoPDF.Value := Mem.Size;
          Application.ProcessMessages;
        until (BytesRead < BufSize);

        {$IFDEF MSWINDOWS}
          Destino := ExtractFilePath(ParamStr(0)) + FileName;
        {$ELSE}
          Destino := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, FileName);
        {$ENDIF}
        Mem.SaveToFile(Destino);

        //Abre o PDF
        {$IFNDEF MWWINDOWS}
          OpenPDF('Teste.pdf');
        {$ENDIF}

        if (Size <> Mem.Size) then
          raise Exception.Create( 'Erro ao baixar...' );

      end
      else
        lblStatus.Text := EmptyStr;
    finally
      FreeMem(Buffer, BufSize);
      FreeAndNIl(Mem);
      lblStatus.Text := EmptyStr;
      pgbProgressoPDF.Max := 0;
      pgbProgressoPDF.Value := 0;
    end;
  except on E: Exception do
    lblMensagem.Text := PChar( E.ClassName + ': ' + E.Message );
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  RetStream  : TStream;
  Buffer     : PByte;
  Mem        : TMemoryStream;
  BytesRead  : Integer;
  DocumentId : Int64;
  Size       : Int64;
  Filename   : String;
  BufSize    : Integer;
  Destino    : String;
  QualImagem : String;
begin
  BufSize := 1024;
  try
    Mem := TMemoryStream.Create;
    GetMem(Buffer, BufSize);
    try
      FileName := cbxImagens.Selected.Text;
      RetStream := CM.ServerMethods1Client.DownloadFile(FileName, Size);
      RetStream.Position := 0;
      if (Size <> 0) then
      begin
        pgbProgresso.Max := Size;
        pgbProgresso.Value := 0;
        FileName := cbxImagens.Selected.Text;
        repeat
          BytesRead := RetStream.Read(Pointer(Buffer)^, BufSize);
          if (BytesRead > 0) then
            Mem.WriteBuffer(Pointer(Buffer)^, BytesRead);

          lblStatus.Text := Format('Baixando %s de %s bytes', [IntToStr(Mem.Size), IntToStr(Size)]);
          pgbProgresso.Value := Mem.Size;
          Application.ProcessMessages;
        until (BytesRead < BufSize);

        {$IFDEF MSWINDOWS}
          Destino := ExtractFilePath(ParamStr(0)) + FileName;
        {$ELSE}
          Destino := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, FileName);
        {$ENDIF}
        Mem.SaveToFile(Destino);
        Image1.Bitmap.LoadFromFile(Destino);

        if (Size <> Mem.Size) then
          raise Exception.Create( 'Erro ao baixar...' );

      end
      else
        lblStatus.Text := EmptyStr;
    finally
      FreeMem(Buffer, BufSize);
      FreeAndNIl(Mem);
      lblStatus.Text := EmptyStr;
      pgbProgresso.Max := 0;
      pgbProgresso.Value := 0;
    end;
  except on E: Exception do
    lblMensagem.Text := PChar( E.ClassName + ': ' + E.Message );
  end;
end;

end.
