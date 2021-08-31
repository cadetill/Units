{
  @abstract(Unit to manage Windows Services)
  @author(Xavier Martinez (cadetill) <cadetill@gmail.com>)
  @created(August 31, 2021)
  @lastmod(August 31, 2021)

  The uServices unit contains the definition and implementation of the classes needed to manage Windows Services.@br
  You can create, delete, start, stop and get status from a Windows Service from a local machino or remote machine

  @bold(Change List) @br
  @unorderedList(
    @item(08/31/2021 : first version)
  )
}
unit uServices;

interface

uses
  Winapi.WinSvc, Winapi.Windows, System.Classes;

type
  {
    @abstract(Support class with information about a Windows Service.)
  }
  TSrvStatus = class
  private
    FServiceStatus: SERVICE_STATUS;
    FDisplayName: string;
    FServiceName: string;
  public
    // The name of a service in the service control manager database.
    property ServiceName: string read FServiceName write FServiceName;
    // A display name that can be used by service control programs, such as Services in Control Panel, to identify the service.
    property DisplayName: string read FDisplayName write FDisplayName;
    // @abstract(structure that contains status information for the @link(ServiceName) service.)
    // For more info see @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_status SERVICE_STATUS structure) on Microsoft website.
    property ServiceStatus: SERVICE_STATUS read FServiceStatus write FServiceStatus;
  end;

  {
    @abstract(Class with all methods needed to manage Windows Services.)
    All methods are a class methods for ease of use
  }
  TServices = class
  public
    // @abstract(Creates a new Windows service.)
    // For more info see @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-createservicea CreateServiceA function) on Microsoft website.
    // @param(Machine string The name of the target computer. If value is an empty string, the function connects to the service control manager on the local computer.)
    // @param(Service string The name of the service to install. The maximum string length must be 256 characters.)
    // @param(DisplayName string The display name to be used by user interface programs to identify the service. The maximum string length must be 256 characters.)
    // @param(BinFile string Path to the service binary file)
    // @param(StartType Integer The service start options.@br
    //          Values:@br
    //            @unorderedList(
    //                @item(SERVICE_AUTO_START : A service started automatically by the service control manager during system startup.)
    //                @item(SERVICE_BOOT_START : A device driver started by the system loader. This value is valid only for driver services.)
    //                @item(SERVICE_DEMAND_START : A service started by the service control manager when a process calls the StartService function.)
    //                @item(SERVICE_DISABLED : A service that cannot be started.)
    //                @item(SERVICE_SYSTEM_START : A device driver started by the IoInitSystem function. This value is valid only for driver services.)
    //            )
    //       )
    // @return(Boolean True if the Service can be created. Otherwise returns False.)
    class function ServiceCreate(Machine, Service, DisplayName, BinFile: string; StartType: Integer): Boolean;
    // @abstract(Deletes an existing Windows service.)
    // For more info see @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-openservicea OpenServiceA function) and @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-deleteservice DeleteService function) on Microsoft website.
    // @param(Machine string The name of the target computer. If value is an empty string, the function connects to the service control manager on the local computer.)
    // @param(Service string The name of the service to uninstall. The maximum string length must be 256 characters.)
    // @return(Boolean True if the Service can be deleted. Otherwise returns False.)
    class function ServiceDelete(Machine, Service: string): Boolean;
    // @abstract(Starts an existing Windows service.)
    // For more info see @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-openservicea OpenServiceA function) and @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-startservicea StartServiceA function)on Microsoft website.
    // @param(Machine string The name of the target computer. If value is an empty string, the function connects to the service control manager on the local computer.)
    // @param(Service string The name of the service to start. The maximum string length must be 256 characters.)
    // @return(Boolean True if the Service can be started. Otherwise returns False.)
    class function ServiceStart(Machine, Service: string): Boolean;
    // @abstract(Stops an existing Windows service.)
    // For more info see @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-openservicea OpenServiceA function) and @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-controlservice ControlService function) on Microsoft website.
    // @param(Machine string The name of the target computer. If value is an empty string, the function connects to the service control manager on the local computer.)
    // @param(Service string The name of the service to stop. The maximum string length must be 256 characters.)
    // @return(Boolean True if the Service can be stopped. Otherwise returns False.)
    class function ServiceStop(Machine, Service: string): Boolean;
    // @abstract(Returns the status of a service.)
    // For more info see @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-queryservicestatus QueryServiceStatus function) and @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_status SERVICE_STATUS structure) on Microsoft website.
    // @param(Machine string The name of the target computer. If value is an empty string, the function connects to the service control manager on the local computer.)
    // @param(Service string The name of the service to stop. The maximum string length must be 256 characters.)
    // @return(DWord The current state of the service.@br
    //          Values:@br
    //            @unorderedList(
    //                @item(SERVICE_CONTINUE_PENDING : The service continue is pending.)
    //                @item(SERVICE_PAUSE_PENDING : The service pause is pending.)
    //                @item(SERVICE_PAUSED : The service is paused.)
    //                @item(SERVICE_RUNNING : The service is running.)
    //                @item(SERVICE_START_PENDING : The service is starting.)
    //                @item(SERVICE_STOP_PENDING : The service is stopping.)
    //                @item(SERVICE_STOPPED : The service is not running.)
    //            )
    //        )
    class function ServiceGetStatus(Machine, Service: string): DWord;
    // @abstract(Returns a list of all Windows services.)
    // Each item from the the returned list has an @link(TSrvStatus) object with information about this Windows Service.@br
    // For more info see @url(https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-enumservicesstatusa EnumServicesStatusA function) on Microsoft website.
    // @param(Machine string The name of the target computer. If value is an empty string, the function connects to the service control manager on the local computer.)
    // @param(SrvType string The type of services to be enumerated.@br
    //          Values:@br
    //            @unorderedList(
    //                @item(SERVICE_DRIVER : Services of type SERVICE_KERNEL_DRIVER and SERVICE_FILE_SYSTEM_DRIVER.)
    //                @item(SERVICE_FILE_SYSTEM_DRIVER : File system driver services.)
    //                @item(SERVICE_KERNEL_DRIVER : Driver services.)
    //                @item(SERVICE_WIN32 : Services of type SERVICE_WIN32_OWN_PROCESS and SERVICE_WIN32_SHARE_PROCESS.)
    //                @item(SERVICE_WIN32_OWN_PROCESS : Services that run in their own processes.)
    //                @item(SERVICE_WIN32_SHARE_PROCESS : Services that share a process with one or more other services.)
    //            )
    //        )
    // @param(SrvState string The state of the services to be enumerated.@br
    //          Values:@br
    //            @unorderedList(
    //                @item(SERVICE_ACTIVE : Enumerates services that are in the following states: SERVICE_START_PENDING, SERVICE_STOP_PENDING, SERVICE_RUNNING, SERVICE_CONTINUE_PENDING, SERVICE_PAUSE_PENDING, and SERVICE_PAUSED.)
    //                @item(SERVICE_INACTIVE : Enumerates services that are in the SERVICE_STOPPED state.)
    //                @item(SERVICE_STATE_ALL : Combines the following states: SERVICE_ACTIVE and SERVICE_INACTIVE.)
    //            )
    //        )
    // @param(SrvList string The list of Windows Services. Each item from this list has an @link(TSrvStatus) object with information about this Windows Service.)
    // @return(Boolean True if the operation success. Otherwise False.)
    class function ServiceGetList(Machine: string; SrvType, SrvState: DWord; SrvList: TStringList): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TServices }

class function TServices.ServiceCreate(Machine, Service, DisplayName,
  BinFile: string; StartType: Integer): Boolean;
var
  schm, schs: SC_Handle;
begin
  schm := OpenSCManager(PChar(Machine), nil, SC_MANAGER_CREATE_SERVICE);
  if (schm > 0) then
  begin
    schs := CreateService(schm,
                          PChar(Service),
                          pchar(DisplayName),
                          SERVICE_ALL_ACCESS,
                          SERVICE_INTERACTIVE_PROCESS or SERVICE_WIN32_OWN_PROCESS,
                          StartType,
                          SERVICE_ERROR_NORMAL,
                          pchar(BinFile),
                          nil,
                          nil,
                          nil,
                          nil,
                          nil);
    if (schs > 0) then
    begin
      Result := True;
      CloseServiceHandle(schs);
    end
    else
      Result := False;
    CloseServiceHandle(schm);
  end
  else
    Result := False;
end;

class function TServices.ServiceDelete(Machine, Service: string): Boolean;
var
  schm, schs: SC_Handle;
begin
  schm := OpenSCManager(PChar(Machine), nil, SC_MANAGER_CREATE_SERVICE);
  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(Service), SERVICE_ALL_ACCESS);
    if (schs > 0) then
    begin
      Result := DeleteService(schs);
      CloseServiceHandle(schs);
    end
    else
      Result := False;
    CloseServiceHandle(schm);
  end
  else
    Result := False;
end;

class function TServices.ServiceGetList(Machine: string; SrvType,
  SrvState: DWord; SrvList: TStringList): Boolean;
const
  cnMaxServices = 4096; // assume that the total number of services is less than 4096. Increase if necessary
type
  TSvcA = array[0..cnMaxServices] of TEnumServiceStatus;
  PSvcA = ^TSvcA;
var
  i: Integer;
  schm: SC_Handle;
  nBytesNeeded: DWord;
  nServices: DWord;
  nResumeHandle: DWord;
  serv: PSvcA;
  ssObj: TSrvStatus;
begin
  Result := False;
  if not Assigned(SrvList) then
    Exit;

  SrvList.Clear;

  schm := OpenSCManager(PChar(Machine), nil, SC_MANAGER_ALL_ACCESS);

  if (schm > 0) then
  begin
    nResumeHandle := 0;
    New(serv);
    EnumServicesStatus(schm, SrvType, SrvState, serv^[0], SizeOf(serv^), nBytesNeeded, nServices, nResumeHandle);

    for i := 0 to nServices - 1 do
    begin
      ssObj := TSrvStatus.Create;
      ssObj.ServiceName := StrPas(serv^[i].lpServiceName);
      ssObj.DisplayName := StrPas(serv^[i].lpDisplayName);
      ssObj.ServiceStatus := serv^[i].ServiceStatus;

      SrvList.AddObject(ssObj.DisplayName, ssObj);
    end;

    Result := True;
    Dispose(serv);

    CloseServiceHandle(schm);
  end;
end;

class function TServices.ServiceGetStatus(Machine, Service: string): DWord;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwStat: DWord;
begin
  dwStat := 0;

  schm := OpenSCManager(PChar(Machine), nil, SC_MANAGER_CONNECT);

  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(Service), SERVICE_QUERY_STATUS);

    if (schs > 0) then
    begin
      if (QueryServiceStatus(schs, ss)) then
        dwStat := ss.dwCurrentState;

      CloseServiceHandle(schs);
    end;

    CloseServiceHandle(schm);
  end;

  Result := dwStat;
end;

class function TServices.ServiceStart(Machine, Service: string): Boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  psTemp: PChar;
  dwChkP: DWord;
begin
  ss.dwCurrentState := 0;
  schm := OpenSCManager(PChar(Machine), nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(Service), SERVICE_START or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      psTemp := nil;
      if (StartService(schs, 0, psTemp)) then
      begin
        if (QueryServiceStatus(schs, ss)) then
        begin
          while (SERVICE_RUNNING <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs, ss)) then
              Break;
            if (ss.dwCheckPoint < dwChkP) then
              Break;
          end;
        end;
      end;
      QueryServiceStatus(schs, ss);
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := SERVICE_RUNNING = ss.dwCurrentState;
end;

class function TServices.ServiceStop(Machine, Service: string): Boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwChkP: DWord;
begin
  schm := OpenSCManager(PChar(Machine), nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(Service), SERVICE_STOP or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      if (ControlService(schs, SERVICE_CONTROL_STOP, ss)) then
      begin
        if (QueryServiceStatus(schs, ss)) then
        begin
          while (SERVICE_STOPPED <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs, ss)) then
              Break;
            if (ss.dwCheckPoint < dwChkP) then
              Break;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := (SERVICE_STOPPED = ss.dwCurrentState);
end;

end.
