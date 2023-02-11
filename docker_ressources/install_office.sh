echo "WINEPREFIX: $WINEPREFIX"
echo "WINEARCH: $WINEARCH"

echo "*" WINETRICKS
winetricks cmd corefonts msxml6 msxml3 riched30 riched20 gdiplus win7

echo "*" DLL OVERRIDES
wine regedit /S dll_overrides.reg

echo "*" GRAPHIC WORKAROUNDS
wine regedit /S graphic_workarounds.reg

# wine regedit
# winecfg

echo "*" OFFICE SETUP
wine OfficeSetup.exe

sleep 2

echo "*" COPY FILES
cp -iv "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Common Files/Microsoft Shared/ClickToRun/AppvIsvSubsystems32.dll" "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Microsoft Office/root/Office16/AppvIsvSubsystems32.dll"
cp -iv "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Common Files/Microsoft Shared/ClickToRun/AppvIsvSubsystems32.dll" "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Microsoft Office/root/Client/AppvIsvSubsystems32.dll"
cp -iv "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Common Files/Microsoft Shared/ClickToRun/C2R32.dll" "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Microsoft Office/root/Office16/C2R32.dll"
cp -iv "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Common Files/Microsoft Shared/ClickToRun/C2R32.dll" "${WINEPREFIX:-~/.wine}/drive_c/Program Files/Microsoft Office/root/Client/C2R32.dll"

echo "*" FINALIZE
wineserver -k