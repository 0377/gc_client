for /r %%s in (*.proto) do (
	protoc3.3.exe --cpp_out ../../gamingcity_server/code/pb_server --proto_path . ./%%~ns.proto
)

if not exist "../../gamingcity_server/project/pb" md "../../gamingcity_server/project/pb"

for /r %%s in (*.proto) do (
	protoc3.3.exe -I . --descriptor_set_out ../../gamingcity_server/project/pb/%%~ns.proto %%~ns.proto
)

if not exist "../../gamingcity_server/project/log" md "../../gamingcity_server/project/log"

pause
