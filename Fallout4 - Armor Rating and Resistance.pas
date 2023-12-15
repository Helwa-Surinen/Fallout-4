{
  Sets the Armor Rating to the selected value 
  Adds all resistances with the same value
  Author: Helwa Surinen (c) 2023
}

unit UserScript;

var
  ArmRat, dtEnergy, dtFire, dtCryo, dtPoison, dtRadiationExposure, dtRadiationIngestion, dtPhysical: integer;
  messageStars, message1, message2: string;
	
function Initialize: integer;
begin
  // Texts and values can be changed according to your needs.
  ArmRat := 10;
  dtEnergy := 15;
  dtFire := 12;
  dtCryo := 14;
  dtPoison := 20;
  dtRadiationExposure := 30;
  dtRadiationIngestion := 20;
  dtPhysical := 8;
  messageStars := '************************************************';
  message1 := 'It is being edited';
  message2 := 'New Armor Rating and Resistance values have been set. Editing finished.';
  Exit
end;

function AddResistance(rec: IInterface; damType: String; value: Integer): IInterface;
var
  resist: IInterface;
begin
  resist := ElementByPath(rec, 'DAMA');
  if not Assigned(resist) then begin
    resist := Add(rec, 'DAMA', false);
    Result := ElementByIndex(resist, 0);
  end
  else
    Result := ElementAssign(resist, HighInteger, nil, False);

  SetElementEditValues(Result, 'Damage Type', damType);
  SetElementNativeValues(Result, 'Value', value);
end;

function Process(e: IInterface): Integer;
begin
  // Adjusts armor only, skip other entries
  if Signature(e) <> 'ARMO' then exit;

  // Armor Rating settings
  SetElementEditValues(e, 'FNAM\Armor Rating', ArmRat);

  // For the sake of duplication, we first delete all existing resistances.
  RemoveElement(e, 'DAMA');

  // We will add new resistances
  AddResistance(e, 'dtEnergy [DMGT:00060A81]', dtEnergy);
  AddResistance(e, 'dtFire [DMGT:00060A82]', dtFire);
  AddResistance(e, 'dtCryo [DMGT:00060A83]', dtCryo);
  //AddResistance(e, 'dtPoison [DMGT:00060A84]', dtPoison);	// The ones we don't want, we comment out the line
  AddResistance(e, 'dtRadiationExposure [DMGT:00060A85]', dtRadiationExposure);
  AddResistance(e, 'dtRadiationIngestion [DMGT:00060A86]', dtRadiationIngestion);
  AddResistance(e, 'dtPhysical [DMGT:00060A87]', dtPhysical);
  AddMessage(message1 + FullPath(e));

end;

function Finalize: integer;
begin
  AddMessage(messageStars);
  AddMessage(message2);
  AddMessage(messageStars);
end;

end.
    
