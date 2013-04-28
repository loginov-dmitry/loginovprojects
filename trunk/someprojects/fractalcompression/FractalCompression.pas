{
Copyright (c) 2006-2009, Loginov Dmitry Sergeevich
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ ������ FractalCompression - �������� ����� TFractal, ������������ ���       }
{ ������������ ������ / ���������� �����������                                }
{ (c) 2006-2009 ������� ������� ���������                                     }
{ ����� �����: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{ ��������� ���������: 07.06.2009                                             }
{                                                                             }
{ *************************************************************************** }

{
��������� � �����������:
  * 07.06.2009 *
  - ������ �������� PByteArray ������������ ������� �� ������ Matrix32.
    �� ���� ����� ��� ���� ����� ��� ���������, ��� ����� ��������������.
  - �������� ��������� TIfsRec (������ ���������� TMemIfsRec).
    ������ ���� Betta: Byte, ����� Betta: ShortInt
    ������� ��������������� �����������. ������ ����������� ������� � �����-
    ������ ������������� - ��� ����������� ������� �������� ���� ��� �����������
    ������� �������. ������ �� ��������������� ������������ ����� ����������
    ����� ����� ������������ �������. ������ ��� �� ����������. ��� ����, �����
    ��������� ������� ������� ����� ��������� � ���������� ShortInt ���
    �������������� ������� �� 2. ��� ������������ ��� ���������� �� 2.
  - ���������� ������, ��������� � ������������ ������������ ����� �� ��������
    ��������� �����������. ����� ��������� ������ ������� � ������, ������
    ����������� ������������ �������������� ����������� �� ������� � �������
    ������� BuildImageWithDomains(). ������ ������� ���������� ���������
    ������������� ������� Matrix32 � ������������ ����� MatrixCheckRange.
  - �������� ��������� TIfsHeader. ������ ���� FileExt ������� �� 4� ��������.
    � ��� ������ ���� �������� "2IFS".
  - ������ �������� � IFS-����� � ���������� �������. ��������� TFileIfsRec
    �������� ������ 5 ���� (������ ���� 6). ������ ������� ��������������
    ��������, ����� ���� �� ������ ���� ��������� �������� � ���������� ���������.
    �������� ���������� ������� SaveToFile() � LoadFromFile().

  * 11.06.2009 *
  - � ������ Decompress � BuildImageWithDomains ��������� �������������� ��������,
    �������������� ������� ���������� �� 0 �� 255. ����������� ���������� �������
    ����� �������. �� ��������� ����� ��� ������ ��������, ������� ������ ������ ����. 
}

unit FractalCompression;

interface

uses
  Windows, Messages, SysUtils, Graphics, Classes, Matrix32;

type
  // ������ �������� ������ ������� � �������� ����� (5 ���� �� 1 ������)
  // ��� �����-����� ����������� ������� ����� ������� ����� �������� 1 ����
  // �.�. ���� ������ ������������ �������� �������� � ����� 1 ����.
  // ��������������, ��� ������������ �� ����� ������� ����������� ��������
  // �������, ��� 4096 � 4096 
  TFileIfsRec = packed record
    FormNum: Byte; // ����� ��������������
    Betta: ShortInt; // ��� ������� � Byte 07.06.2009

    // ���������� ������ �������� ���� ������
    // 0� ���� - ������� ���� �� �
    // 1� ���� - ������� ���� �� �
    // 2� ���� - 4 ��. ���� �� �, ����� 4 ��. ���� �� �
    DomCoordXY: array[0..2] of Byte;
  end;

  // �������� ������ ������� � �������� ����� ���������� �����-������� 6 ����
  // ����� ������� ������ ����� = ���-�� �������� * 6
  TMemIfsRec = packed record
    FormNum: Byte; // ����� ��������������
    Betta: ShortInt; // �������� � �������. ��� ������� � Byte 07.06.2009
    DomCoordX, DomCoordY: Word; // ���������� ������ �������� ���� ������       
  end;

  TRegionRec = packed record
    MeanColor: Integer; // ����������� ������������     
    Ifs: TMemIfsRec; // ���������, ����������� ��� ����������
  end;

  TDomainRec = packed record
    MeanColor: Integer; // ����������� ������������ 
  end;

  // ��������� ����� (9 ����)
  TIfsHeader = packed record
    FileExt: array[1..4] of AnsiChar;
    RegSize: Byte; // ������ �������
    XRegions, YRegions: Word; // ���-�� �������� �� � � �
  end;       

  // ���� ������� ��������������
  TTransformType = (ttRot0, ttRot90, ttRot180, ttRot270, ttSimmX, ttSimmY, ttSimmDiag1, ttSimmDiag2);

  TProgressProc = procedure(Percent: Integer; TimeRemain: Cardinal) of Object;

  TFractal = class(TComponent)
  private
    SourImage: TMatrix;     // ������� ����������� ����� �������������� � �����
    DomainImage: TMatrix;   // ������ �������� ��������� �����������
    SourWidth: Integer;     // ������ ���������� �����������
    SourHeight: Integer;    // ������ ���������� �����������
    FRegionSize: Integer;   // ������ �������
    FDomainOffset: Integer; // �������� �������
    Regions: array of array of TRegionRec; // ���������� � ��������
    Domains: array of array of TDomainRec; // ���������� � �������
    FGamma: Real;
    FMaxImageSize: Integer; // ����������� ���������� ������ �����������
    FStop: Boolean;
    FIfsIsLoad: Boolean; // ���������, ���� �� ��������� ���������� (��������� �� IFS-������)
    FBaseRegionSize: Integer;  // ������ ������� ��� ������

    {������� ������}
    procedure ClearData;

    {���������� �������������� �������� � ���������� Msg}
    procedure Error(Msg: string; Args: array of const);

    {������� ������ ������ Regions �� ������� }
    procedure CreateRegions;

    {�� ��������� ����������� SourImage ������� �������� �����������}
    procedure CreateDomainImage;

    {������� ������ 2-������ Domains, � ������� ��������� ����������� ������������
     ��� ������� ������}
    procedure CreateDomains;

    {���������� ����������� ������� ��� ������� Image � ������� � �. (X, Y)}
    function GetMeanBrigth(Image: TMatrix; X, Y, Width: Integer): Byte;

    function XRegions: Integer; // ����� �������� �� �
    function YRegions: Integer; // ����� �������� �� �

    function XDomains: Integer; // ����� ������� �� �
    function YDomains: Integer; // ����� ������� �� �
    function DomainImageWidth: Integer; // ������ ��������� �����������
    
    procedure SetGamma(const Value: Real);
    procedure SetMaxImageSize(const Value: Integer);

    procedure SetRegionSize(const Value: Integer);
    procedure SetDomainOffset(const Value: Integer);

    {�������������� �������� ������ � �����. � TransformType. ������� �
     �������� ������� ������ ���� ���� �� ������}
    procedure TransformRegion(Sour, Dest: TMatrix; TransformType: TTransformType);

    {���������� ������� (����������� ����������) ����� �������� � �������}
    function GetDifference(Region: TMatrix; DomCoordX, DomCoordY, Betta: Integer): Integer;

    {�������� ��������� ������ �� ������� AllImage � ������ Dest.
     Width - ������ ������� AllImage}
    procedure CopyRegion(AllImage, Dest: TMatrix; X, Y: Integer);
    function GetPixel(X, Y: Integer): Byte;
  public
    constructor Create(AOwner: TComponent); override;

    destructor Destroy; override;

    {��������� ���������� ���� ������. ��� UseAllTransform ����� ���������
     ��� ������� ��������������: ������� � ���������. � ��������� ������
     ����� �������� ������ �������}
    procedure Compress(UseAllTransform: Boolean = True; BackProc: TProgressProc = nil);

    {������������� ��������� ������� ������������ ������}
    procedure Stop;

    {��������� ���������� �����������. IterCount - ���-�� �������� ����������,
     RegSize - ������ ������� � ������������� �����������. ���� ��� ��������
     ����� ��, ��� RegionSize ��� ������, �� ������ ����������� ����� ��� ��� ������.
     ��� ���������� RegSize ������������� ����������� ����������� � ��������}
    procedure Decompress(IterCount: Integer = 15; RegSize: Integer = 0);

    {������ ����������� �� �������. ����� ������������ ����� ����� ������ ��� ����,
     ����� ��������� �������� ������. �����������, ����������� �� �������,
     ������ �� ��������������� �����������, ������ ����� ������� �������������}
    procedure BuildImageWithDomains;

    {���������, ���� �� ��������� ���������� (��������� �� IFS-������, �����������
     ��� ������������). ���� IfsIsLoad=True, �� ����� ����� ������ ������������}
    property IfsIsLoad: Boolean read FIfsIsLoad;

    {������ ����������� (���������, ������������ �� �������, ��� ��������������)}
    property ImageWidth: Integer read SourWidth;

    {������ ����������� (���������, ������������ �� �������, ��� ��������������)}
    property ImageHeight: Integer read SourHeight;

    {���������� �������� ������� ��� ���������� �������}
    property Pixel[X, Y: Integer]: Byte read GetPixel;

    {��������� ������������ ����������� TBitMap ��� ���������� ����������}
    procedure LoadImage(Image: TBitmap);

    {������ ����������� �� ���������� TBitmap. ��� Regions = True �������� ��������
     �����������, ����� �������� �������� ����������� (��� ����� ��, ������
     � 4 ���� ������ �� �������)}
    procedure DrawImage(Image: TBitmap; Regions: Boolean = True);

    {��������� ��������� ������ � �������� ����}
    procedure SaveToFile(FileName: string);

    {��������� �������� ������ �� ��������� �����}
    procedure LoadFromFile(FileName: string);

    {����������, ����� ������ ����� � IFS-����� ����� ����������}
    function GetIFSFileSize(): Cardinal;
  published
    {������������� ������ �������.
     ��������! ������ �������� ������ ������� ����� �������� ����������� ���
     ����������, ��� ��� ����������� ����������� �������������� �
     ������������ � RegionSize}
    property RegionSize: Integer read FRegionSize write SetRegionSize;

    {�������� �������� ������. �� ��������� = 1 (��� ����� �������������
     ��������� �����������, ������� � 4 ���� ������ ���������)}
    property DomainOffset: Integer read FDomainOffset write SetDomainOffset;

    {�������� ����������� �����}
    property Gamma: Real read FGamma write SetGamma;

    {������������ ������ �����������}
    property MaxImageSize: Integer read FMaxImageSize write SetMaxImageSize;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TFractal]);
end;

var
  // ��� ��������� ���������� ���� TMemIfsRec
  ClearIfs: TMemIfsRec;

{ TFractal }

procedure TFractal.ClearData;
begin
  SourImage.Clear;
  DomainImage.Clear;
  SourWidth := 0;
  SourHeight := 0;
  Regions := nil;
  Domains := nil;
end;

procedure TFractal.Compress(UseAllTransform: Boolean = True; BackProc: TProgressProc = nil);
var
  RegX, RegY, DomX, DomY, Error, BestError, Betta, TransNum, TransCount: Integer;
  Region, BaseRegion: TMatrix;
  DCoordX, DCoordY, BestFormNum, BestDomX, BestDomY, BestBetta: Integer;
  Percent: Real;
  Tc, OneRegTime, AllRegTime: Cardinal;
begin
  FStop := False;
  FIfsIsLoad := False;

  FBaseRegionSize := RegionSize;

  if UseAllTransform then
    TransCount := 8
  else
    TransCount := 4;

  if SourImage.ElemCount = 0 then
    raise Exception.Create('����������� ��� ������������ ������ ��� �� ���������!');

  CreateRegions;
  CreateDomains;

  Region := TShortMatrix.Create();
  try
    BaseRegion := TShortMatrix.Create(Region);

    // ������������� ������� ��������� �������� (RegionSize x RegionSize)
    Region.Resize([RegionSize, RegionSize]);
    BaseRegion.Resize([RegionSize, RegionSize]);

    OneRegTime := 0; // ������������ ��������� ������ �������
    AllRegTime := 0; // ����� ������������ ���������
    Tc := GetTickCount;

    // ���������� �������
    for RegY := 0 to YRegions - 1 do
    begin
      for RegX := 0 to XRegions - 1 do
      begin
        // ���������� �����, ���� ���������� ����� 10 ��������
        if RegY * XRegions + RegX > 10 then
          Tc := GetTickCount;

        // ��������� ������� ��������
        Percent := (RegY * XRegions + RegX) / (YRegions * XRegions) * 100;

        // ������������� ���������, ����������� �������� ������� � ������� �����,
        // ����������� �������� �� ����������������.
        BestError := $7FFFFFFF;
        BestFormNum := -1;
        BestDomX := -1;
        BestDomY := -1;
        BestBetta := 0;

        // �������� ��������� ������ �� ��������� ������
        CopyRegion(SourImage, BaseRegion, RegX * RegionSize, RegY * RegionSize);

        // ���������� ������
        for DomY := 0 to YDomains - 1 do
        begin
          for DomX := 0 to XDomains - 1 do
          begin

            // ���������� ������� � �������. ��� ������ ���� ��� ����� �������������.
            Betta := Regions[RegX, RegY].MeanColor - Domains[DomX, DomY].MeanColor;

            // ��������� �������� ������� � �������� �����������
            DCoordX := DomX * DomainOffset;
            DCoordY := DomY * DomainOffset;

            // �������� ���� �� ��������������
            for TransNum := 0 to TransCount - 1 do
            begin
              // ��������� ������� ��������������
              TransformRegion(BaseRegion, Region, TTransformType(TransNum));

              // ���������� �������� ������� ����� ������������������ ��������
              // � ������� �������� ��������� �����������
              Error := GetDifference(Region, DCoordX, DCoordY, Betta);

              // ���������� �� ��������� ���������� ������ ����������
              if Error < BestError then
              begin
                BestError := Error;
                BestFormNum := TransNum;
                BestDomX := DCoordX;
                BestDomY := DCoordY;
                BestBetta := Betta;
              end;

              if FStop then Exit; // ���������� ������� �� ������� ������ Stop
            end;  // ���� �� ��������������
          end;  // ���� �� �������
        end;

        // ������ �������� ���, ��� ����� ��� ������� �������
        with Regions[RegX, RegY].Ifs do
        begin
          DomCoordX := BestDomX;
          DomCoordY := BestDomY;

          // ������� �������� Betta � 2 ����, ����� ���������� � �������� [-128..127]
          BestBetta := BestBetta div 2;

          //ShowMessageFmt('�������� ���������� �������: %d', [BestBetta]);
          if (BestBetta < Low(shortint)) or (BestBetta > High(shortint)) then
            raise Exception.CreateFmt('������������ �������� ��������� Betta: %d', [BestBetta]);

          Betta := BestBetta;

          // ��������� ��������� ��������� �������������, ����� ��� ��������
          // ������ � ��������� ������������.
          if BestFormNum = 1 then BestFormNum := 3 else // 90 -> 270
            if BestFormNum = 3 then BestFormNum := 1;  // 270 -> 90
          FormNum := BestFormNum;
        end;

        // ����� ��������� �������� ������� ������������ ����� ����� ����������.
        if RegY * XRegions + RegX = 10 then
        begin
          OneRegTime := (GetTickCount - Tc) div 10;
          AllRegTime := OneRegTime * Cardinal(XRegions * YRegions);
        end;

        // �������� CallBack-������� ��� ������������ ������ ���������
        if Assigned(BackProc) and (Percent >= 0) then
          BackProc(Trunc(Percent), (AllRegTime - OneRegTime * Cardinal(RegY * XRegions + RegX)) div 1000);

      end; // ���� �� ��������
    end;

    FIfsIsLoad := True; // ����������� ��� �������������� ��������� ���������!
  finally
    Region.FreeMatrix;
  end;
end;

constructor TFractal.Create(AOwner: TComponent);
begin
  inherited;
  FRegionSize := 8;
  DomainOffset := 1;
  Gamma := 0.75;
  MaxImageSize := 512;

  SourImage := TShortMatrix.Create(nil);
  DomainImage := TShortMatrix.Create(nil);
end;

procedure TFractal.CreateDomains;
var
  Y, X: Integer;
begin
  Domains := nil;

  SetLength(Domains, XDomains, YDomains);

  // ��� ������� ������ ���������� ��� ���������� � ����������� �������
  for Y := 0 to YDomains - 1 do
    for X := 0 to XDomains - 1 do
      Domains[X, Y].MeanColor := GetMeanBrigth(DomainImage, X * DomainOffset,
        Y * DomainOffset, DomainImageWidth);
end;

procedure TFractal.CreateRegions;
var
  X, Y: Integer;
begin
  Regions := nil;
  SetLength(Regions, XRegions, YRegions);

  // ��� ������� ������� ���������� ����������� �������
  for Y := 0 to YRegions - 1 do
    for X := 0 to XRegions - 1 do
      Regions[X, Y].MeanColor := GetMeanBrigth(SourImage, X * RegionSize, Y * RegionSize, SourWidth);
end;

destructor TFractal.Destroy;
begin
  ClearData();
  SourImage.FreeMatrix;
  DomainImage.FreeMatrix;
  inherited;
end;

procedure TFractal.DrawImage(Image: TBitmap; Regions: Boolean = True);
var
  X, Y, Pixel: Integer;
  Handle: HDC;
begin     
  if SourWidth * SourHeight < 1 then
    Error('������ ��������� �����������: ������� ������!', []);

  Image.Width := SourWidth;
  Image.Height := SourHeight;
  Handle := Image.Canvas.Handle;

  for Y := 0 to SourImage.Rows - 1 do
  begin
    for X := 0 to SourImage.Cols - 1 do
    begin
      Pixel := SourImage.ElemI[Y, X];
      Pixel := (Pixel shl 16) + (Pixel shl 8) + Pixel;
      SetPixel(Handle, X, Y, Pixel);
    end;
  end;

  // � ����� ������� ���� ������ �������� �����������
  if not Regions then
  begin
    for Y := 0 to DomainImage.Rows - 1 do
    begin
      for X := 0 to DomainImage.Cols - 1 do
      begin
        Pixel := DomainImage.ElemI[Y, X];
        Pixel := (Pixel shl 16) + (Pixel shl 8) + Pixel;
        SetPixel(Handle, X, Y, Pixel);
      end;
    end;
  end;
end;

procedure TFractal.Error(Msg: string; Args: array of const);
begin
  raise Exception.CreateFmt(Msg, Args);
end;

function TFractal.GetMeanBrigth(Image: TMatrix; X, Y, Width: Integer): Byte;
var
  I, J, Bufer: Integer;
begin
  Bufer := 0;
  for I := Y to Y + RegionSize - 1 do
    for J := X to X + RegionSize - 1 do
      Inc(Bufer, Image.ElemI[I, J]);
  Result := Trunc(Bufer / (RegionSize * RegionSize));
end;

procedure TFractal.LoadImage(Image: TBitmap);
var
  X, Y: Integer;
  PixColor: TColor;
  red, green, blue, mask: integer;
begin
  ClearData;  // ������� �������

  SourWidth := (Image.Width div RegionSize) * RegionSize;
  SourHeight := (Image.Height div RegionSize) * RegionSize;

  // ����������� ������ ���� �� ������, ��� 16 � 16
  if (SourWidth > MaxImageSize) or (SourWidth < 16) or
     (SourHeight > MaxImageSize) or (SourHeight < 16)
    then Error('������������ ������� ����������� %d x %d', [Image.Width, Image.Height]);

  // ======= ��������� ������ SourImage (��� ��������) ===========
  // �������� ������ ��� �����������
  SourImage.Resize([SourHeight, SourWidth]);

  // ������ ������� ������ � ��������� �� � ��������� ������� SourImage
  mask := $000000FF;
  for Y := 0 to SourImage.Rows - 1 do
  begin
    for X := 0 to SourImage.Cols - 1 do
    begin
      PixColor := Image.Canvas.Pixels[X, Y]; // ���������� ���� �������
      red := (PixColor shr 16) and mask;
      green := (PixColor shr 8) and mask;
      blue := PixColor and mask;
      SourImage.ElemI[Y, X] := Byte((red + green + blue) div 3);
    end;
  end;
  // ������ ��� ������� �����.

  // ======= ��������� ������ DomenImage (��� �������) ===========
  // ������-�� ������ � 2 ���� ������ ��������, ������ ��-�� ����� �� ������ ����������.
  // � ��� ���� �� �������� ����������� �������� � 4 ���� (�� �������), ��
  // ������ 1 ������ ������ ������ ������� 1 �������, ��� ������� �����
  // � ���������.
  CreateDomainImage;

  FIfsIsLoad := False;
end;

procedure TFractal.SetDomainOffset(const Value: Integer);
begin
  if (Value < 1) or (Value > 32) then
    Error('������ ������������ �������� �������� ������ %d', [Value]);

  FDomainOffset := Value;
end;

procedure TFractal.SetGamma(const Value: Real);
begin
  if (Value < 0.1) or (Value > 1) then
    Error('�������� GAMMA ����� ������������ �������� %d', [Value]);

  FGamma := Value;
end;

procedure TFractal.SetMaxImageSize(const Value: Integer);
begin
  FMaxImageSize := Value;
end;

procedure TFractal.SetRegionSize(const Value: Integer);
begin
  if (Value < 2) or (Value > 64) then
    Error('������ ������������ �������� ������� %d', [Value]);

  FRegionSize := Value;
end;

function TFractal.XDomains: Integer;
begin
  Result := ((SourWidth div 2) - 1) div DomainOffset;

  // ��������� ���������� �������� �������, ����� �� ����� ����
  // ��������� ��������� � �����
  while (Result * DomainOffset + RegionSize) > (SourWidth div 2) do
    Dec(Result);

  if Result <= 1 then
    Error('������������ ���������� ������� �� � %d', [Result]);
end;

function TFractal.YDomains: Integer;
begin
  Result := ((SourHeight div 2) - 1) div DomainOffset;    

  // ��������� ���������� �������� �������, ����� �� ����� ����
  // ��������� ��������� � �����  
  while (Result * DomainOffset + RegionSize) > (SourHeight div 2) do
    Dec(Result);
  
  if Result <= 1 then
    Error('������������ ���������� ������� �� Y %d', [Result]);
end;

function TFractal.XRegions: Integer;
begin
  Result := SourWidth div RegionSize;
end;

function TFractal.YRegions: Integer;
begin
  Result := SourHeight div RegionSize;
end;

procedure TFractal.TransformRegion(Sour, Dest: TMatrix; TransformType: TTransformType);
var
  I, J: Integer;
begin
  case TransformType of
    ttRot0: // ������� �� 0 �������� (������ �������� �������� �������)
      begin
        Dest.CopyFrom(Sour);
      end;

    ttRot90: // ������� �� 90 ��������
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - J) * RegionSize + I] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttRot180: // ������� �� 180 ��������
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - I) * RegionSize + (RegionSize - 1 - J)] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttRot270: // ������� �� 270 ��������
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[J * RegionSize + (RegionSize - 1 - I)] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmX: // ��������� ������������ �
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - I) * RegionSize + J] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmY: // ��������� ������������ �
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[I * RegionSize + (RegionSize - 1 - J)] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmDiag1: // ��������� ��. ������� ���������
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[J * RegionSize + I] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmDiag2: // ��������� ��. �������������� ���������
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - J) * RegionSize + (RegionSize - 1 - I)] := Sour.VecElemI[I * RegionSize + J];
      end;
  end;
end;

function TFractal.DomainImageWidth: Integer;
begin
  Result := SourWidth div 2;
end;

procedure TFractal.LoadFromFile(FileName: string);
var
  X, Y: Integer;
  Header: TIfsHeader;
  OldIfs: TMemIfsRec;
  FileIfs: TFileIfsRec;
  AByte: Byte;
  SameIfsCount: Integer;
begin
  if not FileExists(FileName) then
    Error('���� "%s" �� ����������', [FileName]);

  with TMemoryStream.Create do
  try
    LoadFromFile(FileName);
    Seek(0, soFromBeginning);
    Read(Header, SizeOf(TIfsHeader));
    if Header.FileExt <> '2IFS' then
      Error('���� "%s" ����� ������������ ������!', [FileName]);
    
    SourWidth := Header.XRegions * Header.RegSize;
    SourHeight := Header.YRegions * Header.RegSize;
    RegionSize := Header.RegSize;

    Regions := nil;
    OldIfs := ClearIfs;
    OldIfs.DomCoordX := MaxWord;
    SameIfsCount := 0;

    SetLength(Regions, XRegions, YRegions);
    for Y := 0 to YRegions - 1 do
    begin
      for X := 0 to XRegions - 1 do
      begin
        if SameIfsCount > 0 then
        begin
          Dec(SameIfsCount);
        end else
        begin    
          // ��������� ���� ����
          Read(AByte, SizeOf(AByte));

          if (AByte and $80) = $80 then // ������� ��� ���������� � �������
          begin // ���������� ���� �������
            if OldIfs.DomCoordX = MaxWord then
              raise Exception.Create(
                '�� ����� IFS ��� �������� ���� ������� 0xFF, '+
                '������ ����� ��� �������� ������� �� �������!');

            // ���������� ����� ��������
            SameIfsCount := AByte and $7F; // $7F = 01111111
            Dec(SameIfsCount);
          end else
          begin
            Position := Position - 1; // ������������ �� 1 ���� �����
            Read(FileIfs, SizeOf(FileIfs));
            OldIfs.FormNum := FileIfs.FormNum;
            OldIfs.Betta := FileIfs.Betta;
            OldIfs.DomCoordX := ((FileIfs.DomCoordXY[2] and $F0) shl 4) + FileIfs.DomCoordXY[0];
            OldIfs.DomCoordY := ((FileIfs.DomCoordXY[2] and $0F) shl 8) + FileIfs.DomCoordXY[1];
          end;
        end;

        Regions[X, Y].Ifs := OldIfs; // ���������� ��������� �� ����� ������
      end;
    end;

  finally
    Free;       
  end;

  // ����� ��� ��������������� ��� ������������
  FBaseRegionSize := RegionSize;
  
  FIfsIsLoad := True;
end;

procedure TFractal.SaveToFile(FileName: string);
var
  X, Y: Integer;
  Header: TIfsHeader;
  OldIfs: TMemIfsRec;
  FileIfs: TFileIfsRec;
  AByte: Byte;
  SameIfsCount: Integer;
  ms: TMemoryStream;

  procedure SaveRepeats;
  begin
    if SameIfsCount > 0 then
    begin
      AByte := $80 or Byte(SameIfsCount);
      ms.Write(AByte, SizeOf(AByte));
      SameIfsCount := 0; // �������� �������
    end;
  end;
begin
  if Regions = nil then
    Error('������ ����������� �� ���������!', []);

  if FileExists(FileName) and (not DeleteFile(FileName)) then
    Error('���������� ������� ���� "%s": %s', [FileName, SysErrorMessage(GetLastError)]);

  Header.FileExt := '2IFS';
  Header.RegSize := RegionSize;
  Header.XRegions := XRegions;
  Header.YRegions := YRegions;

  OldIfs := ClearIfs;
  OldIfs.DomCoordX := MaxWord;
  SameIfsCount := 0;

  ms := TMemoryStream.Create();
  try
    // ��������� ������������ ����������
    ms.Write(Header, SizeOf(TIfsHeader));

    // ������� ��������� � ���������� �������.
    // ���� �������, ������ ���� �� ������, ���������� �� ����-���� ����������,
    // �� ���������� � 5-������� �������. ��� ���� 1 ���� ���������� �� ����
    // ��������� DomCoordX � DomCoordY.
    // ���� �� ���� �� ������ ���� ��������� ���������� �������,
    // �� ���������� ������� ��� = 1, � �� ��� ���������� ������������� ��������

    for Y := 0 to YRegions - 1 do
    begin
      for X := 0 to XRegions - 1 do
      begin
        // ���� ������ �������� ������������� ���������� ������ (������ ������
        // �����-����� �����������), �� ���������� ���� ���� ���� FF
        with Regions[X, Y].Ifs do
        begin
          if (DomCoordX = OldIfs.DomCoordX) and (DomCoordY = OldIfs.DomCoordY) and
            (Betta = OldIfs.Betta) and (FormNum = OldIfs.FormNum) then
          begin
            Inc(SameIfsCount);
            if SameIfsCount = High(ShortInt) then // �������������� ������������
              SaveRepeats();
          end else
          begin
            // ���� ������� ���������� IFS �� �������, �� ���������� ����� ��������
            SaveRepeats();

            FileIfs.FormNum := FormNum;
            FileIfs.Betta := Betta;
            FileIfs.DomCoordXY[0] := Byte(DomCoordX);
            FileIfs.DomCoordXY[1] := Byte(DomCoordY);
            FileIfs.DomCoordXY[2] := ((Regions[X, Y].Ifs.DomCoordX and $0F00) shr 4) or
              ((Regions[X, Y].Ifs.DomCoordY and $0F00) shr 8);

            ms.Write(FileIfs, SizeOf(FileIfs));
          end;
        end;

        // ���������� ������������ ������
        OldIfs := Regions[X, Y].Ifs;
      end;
    end;

    // ��������� �������, ���� ��� ����
    SaveRepeats();

    ms.SaveToFile(FileName);
  finally
    ms.Free;
  end; 
end;

procedure TFractal.Decompress(IterCount: Integer = 15; RegSize: Integer = 0);
var
  I, J, X, Y, Pixel, Iter: Integer;
  Domain1, Domain2: TMatrix;
  Scale: Real;
begin
  // ������ Region ������ ���� ��� �����������.
  if not FIfsIsLoad then
    Error('������, ����������� ��� ������������, �� ���������!', []);

  Scale := 1;

  if RegSize >= 2 then
  begin
    SourWidth := XRegions * RegSize;
    SourHeight := YRegions * RegSize;
    Scale := FBaseRegionSize / RegSize;
    RegionSize := RegSize;
  end;

  // ������� ����� �����������.
  SourImage.Resize([SourHeight, SourWidth]);
  // ������ ������� ������ � ��������� �� � ��������� ������� SourImage
  SourImage.FillByValue(127);
  Domain1 := TShortMatrix.Create();
  try
    Domain2 := TShortMatrix.Create(Domain1);
    Domain1.Resize([RegionSize, RegionSize]);
    Domain2.Resize([RegionSize, RegionSize]);

    for Iter := 1 to IterCount do
    begin
      // ������� �������� �����������
      CreateDomainImage;
      // �������� ����������� �������

      // �������� �� ���� ��������
      for J := 0 to YRegions - 1 do
      begin
        for I := 0 to XRegions - 1 do
        begin
          // ���������� ��������������� �����, ����� ��� ��� ����� ���� ��������� ��������������
          CopyRegion(DomainImage, Domain1,
            Trunc(Regions[I, J].Ifs.DomCoordX / Scale),
            Trunc(Regions[I, J].Ifs.DomCoordY / Scale));

          // ��������� �������� ��������������
          TransformRegion(Domain1, Domain2, TTransformType(Regions[I, J].Ifs.FormNum));

          // �������� ������� �������� �������
          for Y := 0 to RegionSize - 1 do
          begin
            for X := 0 to RegionSize - 1 do
            begin
              Pixel := Domain2.ElemI[Y, X] + Regions[I, J].Ifs.Betta * 2;    

              if Pixel > 255 then
                Pixel := 255
              else if Pixel < 0 then
                Pixel := 0;

              SourImage.ElemI[J * RegionSize + Y, I * RegionSize + X] := Pixel;
            end;
          end;
        end;
      end;
    end; // for Iter
  finally
    Domain1.FreeMatrix;
  end;   
end;

procedure TFractal.CreateDomainImage;
var
  X, Y, PixColor: Integer;
begin
  // �������� ������ ��� �������� ����������� (� 4 ���� ������, ��� � ���������)
  DomainImage.Resize([SourImage.Rows div 2, SourImage.Cols div 2]);

  for Y := 0 to DomainImage.Rows - 1 do
  begin
    for X := 0 to DomainImage.Cols - 1 do
    begin
      // ���������� ����������� ���� ������� (�� ������ 4-� �������� ��������)
      PixColor :=
        SourImage.ElemI[Y * 2, X * 2] + SourImage.ElemI[Y * 2, X * 2 + 1] +           // 1 2
        SourImage.ElemI[Y * 2 + 1, X * 2] + SourImage.ElemI[Y * 2 + 1, X * 2 + 1];    // 3 4

      // ����� �� 4 � �������� �� �����  
      DomainImage.ElemI[Y, X] := Trunc(PixColor / 4 * Gamma);
    end;
  end;
end;

function TFractal.GetDifference(Region: TMatrix; DomCoordX,
  DomCoordY, Betta: Integer): Integer;
var
  X, Y, Diff: Integer;
begin
  Result := 0;
  for Y := 0 to RegionSize - 1 do
    for X := 0 to RegionSize - 1 do
    begin
      Diff := Region.ElemI[Y, X] -
        DomainImage.ElemI[DomCoordY + Y, DomCoordX + X];

      Inc(Result, Sqr(Abs(Diff - Betta)));
    end;
end;

procedure TFractal.CopyRegion(AllImage, Dest: TMatrix; X, Y: Integer);
var
  I, J: Integer;
begin
  for I := 0 to Dest.Rows - 1 do
    for J := 0 to Dest.Cols - 1 do
      Dest.ElemI[I, J] := AllImage.ElemI[Y + I, X + J];
end;

procedure TFractal.BuildImageWithDomains;
var
  I, J, X, Y, Pixel: Integer;
  Domain1, Domain2: TMatrix;
begin
  if not FIfsIsLoad then
    Error('������, ����������� ��� �������������� �� �������, �� ���������!', []);

  Domain1 := TShortMatrix.Create();
  try
    Domain2 := TShortMatrix.Create(Domain1);

    Domain1.Resize([RegionSize, RegionSize]);
    Domain2.Resize([RegionSize, RegionSize]);

    for J := 0 to YRegions - 1 do
    begin
      for I := 0 to XRegions - 1 do
      begin
        // �������� �����
        CopyRegion(DomainImage, Domain1, Regions[I, J].Ifs.DomCoordX,
          Regions[I, J].Ifs.DomCoordY);

        // ��������� ������� ��������������
        TransformRegion(Domain1, Domain2, TTransformType(Regions[I, J].Ifs.FormNum));

        // �������� ����� � ������
        for Y := 0 to RegionSize - 1 do
          for X := 0 to RegionSize - 1 do
          begin
            Pixel := Domain2.ElemI[Y, X] + Regions[I, J].Ifs.Betta * 2;
            
            if Pixel > 255 then
              Pixel := 255
            else if Pixel < 0 then
              Pixel := 0;

            SourImage.ElemI[J * RegionSize + Y, I * RegionSize + X] := Pixel
          end;
      end;
    end;
  finally
    Domain1.FreeMatrix;
  end;    
end;

procedure TFractal.Stop;
begin
  FStop := True;
end;

function TFractal.GetPixel(X, Y: Integer): Byte;
begin
  Result := SourImage.ElemI[Y, X];
end;

function TFractal.GetIFSFileSize: Cardinal;
begin
  Result := (ImageWidth div RegionSize) * (ImageHeight div RegionSize) * SizeOf(TFileIfsRec);
  if Result > 0 then Inc(Result, SizeOf(TIfsHeader));
end;

end.
