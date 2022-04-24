unit solipadplugin;

interface

uses
  NppPlugin, SysUtils, Windows, SciSupport, AboutForms, solipadpluginforms;

type
  TSolipadPlugin = class(TNppPlugin)
  public
    constructor Create;
    procedure FuncSolipad;
    procedure FuncAbout;
  end;

procedure _FuncSolipad; cdecl;
procedure _FuncAbout; cdecl;

var
  Npp: TSolipadPlugin;

implementation

{ TSolipadPlugin }

constructor TSolipadPlugin.Create;
begin
  inherited;
  self.PluginName := 'Solipad Crypt';

  self.AddFuncItem('Proteksi', _FuncSolipad);

  self.AddFuncItem('-', _FuncSolipad);

  self.AddFuncItem('Prihal', _FuncAbout);
end;

procedure _FuncAbout; cdecl;
begin
  Npp.FuncAbout;
end;
procedure _FuncSolipad; cdecl;
begin
  Npp.FuncSolipad;
end;

procedure TSolipadPlugin.FuncAbout;
var
  a: TAboutForm;
begin
  a := TAboutForm.Create(self);
  a.ShowModal;
  a.Free;
end;

procedure TSolipadPlugin.FuncSolipad;
begin
  if (not Assigned(SolipadPluginForm)) then SolipadPluginForm := TSolipadPluginForm.Create(self, 1);
  SolipadPluginForm.Show;
end;

initialization
  Npp := TSolipadPlugin.Create;
end.
