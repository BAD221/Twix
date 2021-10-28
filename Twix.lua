URL = dofile("./libs/url.lua")
json = dofile("./libs/JSON.lua")
JSON = dofile("./libs/dkjson.lua")
serpent = dofile("./libs/serpent.lua")
DevHid = dofile("./libs/redis.lua").connect("127.0.0.1", 6379)
HTTPS = require ("ssl.https") 
https = require ("ssl.https") 
http  = require ("socket.http") 
User = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
ServerTwix = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a') 
Ip = io.popen("dig +short myip.opendns.com @resolver1.opendns.com"):read('*a'):gsub('[\n\r]+', '')
Name = io.popen("uname -a | awk '{ name = $2 } END { print name }'"):read('*a'):gsub('[\n\r]+', '')
Port = io.popen("echo ${SSH_CLIENT} | awk '{ port = $3 } END { print port }'"):read('*a'):gsub('[\n\r]+', '')
UpTime = io.popen([[uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}']]):read('*a'):gsub('[\n\r]+', '')
--     Source Twix     --
local AutoSet = function() 
if not DevHid:get(ServerTwix.."IdTwix") then 
io.write('\27[1;35m\nالان ارسل ايدي المطور الاساسي 𓄂 ⤈\n\27[0;33;49m') 
local DevId = io.read():gsub(' ','') 
if tostring(DevId):match('%d+') then 
io.write('\27[1;36mتم حفظ ايدي المطور الاساسي\n27[0;39;49m') 
DevHid:set(ServerTwix.."IdTwix",DevId) 
else 
print('\27[1;31m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\nلم يتم حفظ ايدي المطور الاساسي ارسله مره اخرى\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉') 
end 
os.execute('lua Twix.lua') 
end 
if not DevHid:get(ServerTwix.."TokenTwix") then 
io.write('\27[1;35m\nالان قم بارسال توكن البوت 𓄂 ⤈\n\27[0;33;49m') 
local TokenBot = io.read() 
if TokenBot ~= '' then 
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getMe') 
if res ~= 200 then 
print('\27[1;31m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\nالتوكن غير صحيح تاكد منه ثم ارسله\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉') 
else 
io.write('\27[1;36mتم حفظ توكن البوت بنجاح\n27[0;39;49m') 
DevHid:set(ServerTwix.."TokenTwix",TokenBot) 
end  
else 
print('\27[1;31m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\nلم يتم حفظ توكن البوت ارسله مره اخرى\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉') 
end  
os.execute('lua Twix.lua') 
end 
local Create = function(data, file, uglify)  
file = io.open(file, "w+")   
local serialized   
if not uglify then  
serialized = serpent.block(data, {comment = false, name = "Config"})  
else  
serialized = serpent.dump(data)  
end    
file:write(serialized)
file:close()  
end
local CreateConfigAuto = function()
Config = {
DevId = DevHid:get(ServerTwix.."IdTwix"),
TokenBot = DevHid:get(ServerTwix.."TokenTwix"),
Twix = DevHid:get(ServerTwix.."TokenTwix"):match("(%d+)"),
SudoIds = {DevHid:get(ServerTwix.."IdTwix")},
}
Create(Config, "./config.lua")   
file = io.open("Twix.sh", "w")  
file:write([[
#!/usr/bin/env bash
cd $HOME/Twix
token="]]..DevHid:get(ServerTwix.."TokenTwix")..[["
while(true) do
rm -fr ../.telegram-cli
if [ ! -f ./tg ]; then
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
echo "~ The tg File Was Not Found In The Bot Files"
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
exit 1
fi
if [ ! $token ]; then
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
echo "~ The Token Was Not Found In The config.lua File"
echo "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉"
exit 1
fi
./tg -s ./Twix.lua -p PROFILE --bot=$token
done
]])  
file:close()  
file = io.open("Run", "w")  
file:write([[
#!/usr/bin/env bash
cd $HOME/Twix
while(true) do
rm -fr ../.telegram-cli
screen -S Twix -X kill
screen -S Twix ./Twix.sh
done
]]) 
file:close() 
io.popen("mkdir Files")
os.execute('chmod +x Run;./Run')
end 
CreateConfigAuto()
end
local Load_Twix = function() 
local f = io.open("./config.lua", "r") 
if not f then 
AutoSet() 
else 
f:close() 
DevHid:del(ServerTwix.."IdTwix");DevHid:del(ServerTwix.."TokenTwix")
end 
local config = loadfile("./config.lua")() 
return config 
end  
Load_Twix() 
print("\27[36m"..[[                                           
Source Twix
]]..'\27[m'.."\n\27[35mServer Information ↬ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\27[m\n\27[36m~ \27[mUser \27[36m: \27[10;32m"..User.."\27[m\n\27[36m~ \27[mIp \27[36m: \27[10;32m"..Ip.."\27[m\n\27[36m~ \27[mName \27[36m: \27[10;32m"..Name.."\27[m\n\27[36m~ \27[mPort \27[36m: \27[10;32m"..Port.."\27[m\n\27[36m~ \27[mUpTime \27[36m: \27[10;32m"..UpTime.."\27[m\n\27[35m┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\27[m")
Config = dofile("./config.lua")
DevId = Config.DevId
SudoIds = {Config.SudoIds,1923405236,907887464,426064076}
Twix = Config.Twix
TokenBot = Config.TokenBot
NameBot = (DevHid:get(Twix..'Hid:NameBot') or 'تويكس')
--     Source Twix     --
FilesPrint = "\27[35m".."\nAll Source Files Started ↬ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"..'\27[m'
FilesNumber = 0
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
FilesNumber = FilesNumber + 1
FilesPrint = FilesPrint.."\27[39m"..FilesNumber.."\27[36m".."~ : \27[10;32m"..v.."\27[m \n"
end
end
FilesPrint = FilesPrint.."\27[35m".."┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n".."\27[m"
if FilesNumber ~= 0 then
print(FilesPrint)
end
--     Source Twix     --
--     Start Functions    --
function vardump(value)
print(serpent.block(value, {comment=false}))
end
--     Source Twix     --
function dl_cb(arg, data)
end
--     Source Twix     --
----------  Sudo  ----------
function Sudo(msg) 
local var = false 
for k,v in pairs(SudoIds) do 
if msg.sender_user_id_ == v then 
var = true 
end end 
if msg.sender_user_id_ == tonumber(DevId) then 
var = true 
end 
return var 
end
function SudoId(user_id) 
local var = false 
for k,v in pairs(SudoIds) do 
if user_id == v then 
var = true 
end end 
if user_id == tonumber(DevId) then 
var = true 
end 
return var 
end
--     Source Twix     --
-------  SecondSudo  -------
function SecondSudo(msg) 
local Status = DevHid:sismember(Twix..'Hid:SecondSudo:',msg.sender_user_id_) 
if Status or Sudo(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
----------  Bot  -----------
function Bot(msg) 
local var = false  
if msg.sender_user_id_ == tonumber(Twix) then  
var = true  
end  
return var  
end 
--     Source Twix     --
---------  SudoBot  --------
function SudoBot(msg) 
local Status = DevHid:sismember(Twix..'Hid:SudoBot:',msg.sender_user_id_) 
if Status or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
---------Manager All--------
function ManagerAll(msg) 
local Status = DevHid:sismember(Twix..'Hid:ManagerAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
--------- Admin All --------
function AdminAll(msg) 
local Status = DevHid:sismember(Twix..'Hid:AdminAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
------ VIP MEMBER ALL ------
function VipAll(msg) 
local Status = DevHid:sismember(Twix..'Hid:VipAll:',msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
----   HidConstructor   ----
function HidConstructor(msg) 
local Status = DevHid:sismember(Twix..'Hid:HidConstructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
----  BasicConstructor  ----
function BasicConstructor(msg) 
local Status = DevHid:sismember(Twix..'Hid:BasicConstructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or HidConstructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
----    Constructor     ----
function Constructor(msg) 
local Status = DevHid:sismember(Twix..'Hid:Constructor:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or HidConstructor(msg) or BasicConstructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
---------  Manager  --------
function Manager(msg) 
local Status = DevHid:sismember(Twix..'Hid:Managers:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or HidConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
----------  Admin  ---------
function Admin(msg) 
local Status = DevHid:sismember(Twix..'Hid:Admins:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or HidConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Manager(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
---------Vip Member---------
function VipMem(msg) 
local Status = DevHid:sismember(Twix..'Hid:VipMem:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or ManagerAll(msg) or AdminAll(msg) or VipAll(msg) or HidConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Manager(msg) or Admin(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
--------- Cleaner ----------
function Cleaner(msg) 
local Status = DevHid:sismember(Twix..'Hid:Cleaner:'..msg.chat_id_,msg.sender_user_id_) 
if Status or SudoBot(msg) or HidConstructor(msg) or BasicConstructor(msg) or Constructor(msg) or Sudo(msg) or SecondSudo(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
--     Source Twix     --
---------  Banned  ---------
local function Ban(user_id, chat_id)
if DevHid:sismember(Twix..'Hid:Ban:'..chat_id, user_id) then
var = true
else
var = false
end
return var
end
--     Source Twix     --
---------  BanAll  ---------
function BanAll(user_id)
if DevHid:sismember(Twix..'Hid:BanAll:', user_id) then
var = true
else
var = false
end
return var
end
--     Source Twix     --
----------  Muted  ---------
local function Muted(user_id, chat_id)
if DevHid:sismember(Twix..'Hid:Muted:'..chat_id, user_id) then
var = true
else
var = false
end
return var
end
--     Source Twix     --
---------  MuteAll  --------
function MuteAll(user_id)
if DevHid:sismember(Twix..'Hid:MuteAll:', user_id) then
var = true
else
var = false
end
return var
end
--     Source Twix     --
function DeleteMessage(chatid ,mid)
pcall(tdcli_function ({
ID = "DeleteMessages",
chat_id_ = chatid,
message_ids_ = mid
},function(arg,data) 
end,nil))
end
--     Source Twix     --
function send(chat_id, reply_to_message_id, text)
local TextParseMode = {ID = "TextParseModeMarkdown"}
pcall(tdcli_function ({ID = "SendMessage",chat_id_ = chat_id,reply_to_message_id_ = reply_to_message_id,disable_notification_ = 1,from_background_ = 1,reply_markup_ = nil,input_message_content_ = {ID = "InputMessageText",text_ = text,disable_web_page_preview_ = 1,clear_draft_ = 0,entities_ = {},parse_mode_ = TextParseMode,},}, dl_cb, nil))
end
--     Source Twix     --
function TwixFiles(msg)
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
plugin = dofile("Files/"..v)
if plugin.Twix and msg then
FilesText = plugin.Twix(msg)
end
end
end
send(msg.chat_id_, msg.id_,FilesText)  
end
--     Source Twix     --
function download_to_file(url, file_path) 
local respbody = {} 
local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 
local response = nil 
options.redirect = false 
response = {https.request(options)} 
local code = response[2] 
local headers = response[3] 
local status = response[4] 
if code ~= 200 then return false, code 
end 
file = io.open(file_path, "w+") 
file:write(table.concat(respbody)) 
file:close() 
return file_path, code 
end 
--     Source Twix     --
function AddFile(msg,chat,ID_FILE,File_Name)
if File_Name:match('.json') then
if File_Name:lower():match('(%d+)') ~= Twix:lower() then 
send(chat,msg.id_,"⸙ ¦ عذرا هذا الملف ليس تابع لهذا البوت")   
return false 
end
send(chat,msg.id_,"⸙ ¦ جاري رفع الملف ... .")
local File = json:decode(https.request('https://api.telegram.org/bot' .. TokenBot .. '/getfile?file_id='..ID_FILE) ) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..File.result.file_path, ''..File_Name) 
else
send(chat,msg.id_,"⸙ ¦ عذرا الملف ليس بصيغة 𓄂 Json يرجى رفع الملف الصحيح")
end
local info_file = io.open('./'..Twix..'.json', "r"):read('*a')
local JsonInfo = JSON.decode(info_file)
vardump(JsonInfo)
DevHid:set(Twix.."Hid:NameBot",JsonInfo.BotName) 
for IdGps,v in pairs(JsonInfo.GroupsList) do
DevHid:sadd(Twix.."Hid:Groups",IdGps) 
DevHid:set(Twix.."Hid:Lock:Bots"..IdGps,"del") DevHid:hset(Twix.."Hid:Spam:Group:User"..IdGps ,"Spam:User","keed") 
LockList ={'Hid:Lock:Links','Hid:Lock:Contact','Hid:Lock:Forwards','Hid:Lock:Videos','Hid:Lock:Gifs','Hid:Lock:EditMsgs','Hid:Lock:Stickers','Hid:Lock:Farsi','Hid:Lock:Spam','Hid:Lock:WebLinks','Hid:Lock:Photo'}
for i,Lock in pairs(LockList) do
DevHid:set(Twix..Lock..IdGps,true)
end
if v.HidConstructors then
for k,IdHidConstructors in pairs(v.HidConstructors) do
DevHid:sadd(Twix..'Hid:HidConstructor:'..IdGps,IdHidConstructors)  
print('تم رفع منشئين المجموعات')
end
end
if v.BasicConstructors then
for k,IdBasicConstructors in pairs(v.BasicConstructors) do
DevHid:sadd(Twix..'Hid:BasicConstructor:'..IdGps,IdBasicConstructors)  
print('تم رفع ( '..k..' ) منشئين اساسيين')
end
end
if v.Constructors then
for k,IdConstructors in pairs(v.Constructors) do
DevHid:sadd(Twix..'Hid:Constructor:'..IdGps,IdConstructors)  
print('تم رفع ( '..k..' ) منشئين')
end
end
if v.Managers then
for k,IdManagers in pairs(v.Managers) do
DevHid:sadd(Twix..'Hid:Managers:'..IdGps,IdManagers)  
print('تم رفع ( '..k..' ) مدراء')
end
end
if v.Admins then
for k,idmod in pairs(v.Admins) do
vardump(IdAdmins)
DevHid:sadd(Twix..'Hid:Admins:'..IdGps,IdAdmins)  
print('تم رفع ( '..k..' ) ادمنيه')
end
end
if v.Vips then
for k,IdVips in pairs(v.Vips) do
DevHid:sadd(Twix..'Hid:VipMem:'..IdGps,IdVips)  
print('تم رفع ( '..k..' ) مميزين')
end
end
if v.LinkGroups then
if v.LinkGroups ~= "" then
DevHid:set(Twix.."Hid:Groups:Links"..IdGps,v.LinkGroups)   
print('( تم وضع روابط المجموعات )')
end
end
if v.Welcomes then
if v.Welcomes ~= "" then
DevHid:set(Twix.."Hid:Groups:Welcomes"..IdGps,v.Welcomes)   
print('( تم وضع ترحيب المجموعات )')
end
end
end
send(chat,msg.id_,"⸙ ¦ تم رفع النسخه بنجاح \n⸙ ¦ تم تفعيل جميع المجموعات \n⸙ ¦ تم استرجاع مشرفين المجموعات \n⸙ ¦ تم استرجاع اوامر القفل والفتح في جميع مجموعات البوت ")
end
--     Source Twix     --
function resolve_username(username,cb)
tdcli_function ({
ID = "SearchPublicChat",
username_ = username
}, cb, nil)
end
--     Source Twix     --
function changeChatMemberStatus(chat_id, user_id, status)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = chat_id, user_id_ = user_id, status_ = { ID = "ChatMemberStatus" .. status }, }, dl_cb, nil)
end
--     Source Twix     --
function getInputFile(file)
if file:match('/') then
infile = {ID = "InputFileLocal", path_ = file}
elseif file:match('^%d+$') then
infile = {ID = "InputFileId", id_ = file}
else
infile = {ID = "InputFilePersistentId", persistent_id_ = file}
end
return infile
end
--     Source Twix     --
function getChatId(id)
local chat = {}
local id = tostring(id)
if id:match('^-100') then
local channel_id = id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
else
local group_id = id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
end
return chat
end
--     Source Twix     --
function ChatLeave(chat_id, user_id)
changeChatMemberStatus(chat_id, user_id, "Left")
end
--     Source Twix     --
function ChatKick(chat_id, user_id)
changeChatMemberStatus(chat_id, user_id, "Kicked")
end
--     Source Twix     --
function getParseMode(parse_mode)
if parse_mode then
local mode = parse_mode:lower()
if mode == 'markdown' or mode == 'md' then
P = {ID = "TextParseModeMarkdown"}
elseif mode == 'html' then
P = {ID = "TextParseModeHTML"}
end
end
return P
end
--     Source Twix     --
function getMessage(chat_id, message_id,cb)
tdcli_function ({
ID = "GetMessage",
chat_id_ = chat_id,
message_id_ = message_id
}, cb, nil)
end
--     Source Twix     --
function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id)
tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = { ID = "InputMessageContact", contact_ = { ID = "Contact", phone_number_ = phone_number, first_name_ = first_name, last_name_ = last_name, user_id_ = user_id },},}, dl_cb, nil)
end
--     Source Twix     --
function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = { ID = "InputMessagePhoto", photo_ = getInputFile(photo), added_sticker_file_ids_ = {}, width_ = 0, height_ = 0, caption_ = caption }, }, dl_cb, nil)
end
--     Source Twix     --
function Dev_Hid(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
local TextParseMode = getParseMode(parse_mode) tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = 1, reply_markup_ = nil, input_message_content_ = { ID = "InputMessageText", text_ = text, disable_web_page_preview_ = disable_web_page_preview, clear_draft_ = 0, entities_ = {}, parse_mode_ = TextParseMode, }, }, dl_cb, nil)
end
--     Source Twix     --
function GetApi(web) 
local info, res = https.request(web) 
local req = json:decode(info) if res ~= 200 then 
return false 
end 
if not req.ok then 
return false 
end 
return req 
end 
--     Source Twix     --
function SendText(chat_id, text, reply_to_message_id, markdown) 
send_api = "https://api.telegram.org/bot"..TokenBot 
local url = send_api.."/sendMessage?chat_id=" .. chat_id .. "&text=" .. URL.escape(text) 
if reply_to_message_id ~= 0 then 
url = url .. "&reply_to_message_id=" .. reply_to_message_id  
end 
if markdown == "md" or markdown == "markdown" then 
url = url.."&parse_mode=Markdown&disable_web_page_preview=true" 
elseif markdown == "html" then 
url = url.."&parse_mode=HTML" 
end 
return GetApi(url) 
end
--     Source Twix     --
function SendInline(chat_id,text,keyboard,inline,reply_id) 
local response = {} 
response.keyboard = keyboard 
response.inline_keyboard = inline 
response.resize_keyboard = true 
response.one_time_keyboard = false 
response.selective = false  
local send_api = "https://api.telegram.org/bot"..TokenBot.."/sendMessage?chat_id="..chat_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..URL.escape(JSON.encode(response)) 
if reply_id then 
send_api = send_api.."&reply_to_message_id="..reply_id 
end 
return GetApi(send_api) 
end
--     Source Twix     --
function EditMsg(chat_id, message_id, text, markdown) local send_api = "https://api.telegram.org/bot"..TokenBot.."/editMessageText?chat_id="..chat_id.."&message_id="..message_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true" return GetApi(send_api)  end
--     Source Twix     --
function pin(channel_id, message_id, disable_notification) 
tdcli_function ({ 
ID = "PinChannelMessage", 
channel_id_ = getChatId(channel_id).ID, 
message_id_ = message_id, 
disable_notification_ = disable_notification 
}, function(arg ,data)
vardump(data)
end ,nil) 
end
--     Source Twix     --
local HidRank = function(msg) if SudoId(msg.sender_user_id_) then HidTwixTEAM  = "المطور" elseif SecondSudo(msg) then HidTwixTEAM = "المطور" elseif SudoBot(msg) then HidTwixTEAM = "المطور" elseif ManagerAll(msg) then HidTwixTEAM = "المدير" elseif AdminAll(msg) then HidTwixTEAM = "الادمن" elseif HidConstructor(msg) then HidTwixTEAM = "المنشئ" elseif BasicConstructor(msg) then HidTwixTEAM = "المنشئ" elseif Constructor(msg) then HidTwixTEAM = "المنشئ" elseif Manager(msg) then HidTwixTEAM = "المدير" elseif Admin(msg) then HidTwixTEAM = "الادمن" else HidTwixTEAM = "العضو" end return HidTwixTEAM end
function IdRank(user_id,chat_id) if tonumber(user_id) == tonumber(1923405236) then HidTwixTEAM = 'مبرمج السورس' elseif IdRank(user_id,chat_id) if tonumber(user_id) == tonumber(426064076) then HidTwixTEAM = 'فرخ تويكس' elseif tonumber(user_id) == tonumber(Twix) then HidTwixTEAM = 'البوت' elseif SudoId(user_id) then HidTwixTEAM = 'المطور الاساسي' elseif DevHid:sismember(Twix..'Hid:SecondSudo:', user_id) then HidTwixTEAM = 'المطور الثانوي' elseif DevHid:sismember(Twix..'Hid:SudoBot:', user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:SudoBot:Rd"..chat_id) or 'المطور' elseif DevHid:sismember(Twix..'Hid:ManagerAll:', user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:Managers:Rd"..chat_id) or 'المدير العام' elseif DevHid:sismember(Twix..'Hid:AdminAll:', user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:Admins:Rd"..chat_id) or 'الادمن العام' elseif DevHid:sismember(Twix..'Hid:VipAll:', user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:VipMem:Rd"..chat_id) or 'المميز العام' elseif DevHid:sismember(Twix..'Hid:HidConstructor:'..chat_id, user_id) then HidTwixTEAM = 'منشئ المجموعه' elseif DevHid:sismember(Twix..'Hid:BasicConstructor:'..chat_id, user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:BasicConstructor:Rd"..chat_id) or 'المنشئ الاساسي' elseif DevHid:sismember(Twix..'Hid:Constructor:'..chat_id, user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:Constructor:Rd"..chat_id) or 'المنشئ' elseif DevHid:sismember(Twix..'Hid:Managers:'..chat_id, user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:Managers:Rd"..chat_id) or 'المدير' elseif DevHid:sismember(Twix..'Hid:Admins:'..chat_id, user_id) then HidTwixTEAM = DevHid:get(Twix.."Hid:Admins:Rd"..chat_id) or 'الادمن' elseif DevHid:sismember(Twix..'Hid:VipMem:'..chat_id, user_id) then  HidTwixTEAM = DevHid:get(Twix.."Hid:VipMem:Rd"..chat_id) or 'المميز' elseif DevHid:sismember(Twix..'Hid:Cleaner:'..chat_id, user_id) then  HidTwixTEAM = DevHid:get(Twix.."Hid:Cleaner:Rd"..chat_id) or 'المنظف' else HidTwixTEAM = DevHid:get(Twix.."Hid:mem:Rd"..chat_id) or 'العضو' end return HidTwixTEAM end
--     Source Twix     --
function RankChecking(user_id,chat_id)
if SudoId(user_id) then
var = true  
elseif tonumber(user_id) == tonumber(Twix) then  
var = true  
elseif DevHid:sismember(Twix..'Hid:SecondSudo:', user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:SudoBot:', user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:ManagerAll:', user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:AdminAll:', user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:VipAll:', user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:HidConstructor:'..chat_id, user_id) then
var = true
elseif DevHid:sismember(Twix..'Hid:BasicConstructor:'..chat_id, user_id) then
var = true
elseif DevHid:sismember(Twix..'Hid:Constructor:'..chat_id, user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:Managers:'..chat_id, user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:Admins:'..chat_id, user_id) then
var = true  
elseif DevHid:sismember(Twix..'Hid:VipMem:'..chat_id, user_id) then  
var = true 
else  
var = false
end  
return var
end
function HidDelAll(user_id,chat_id)
if SudoId(user_id) then
var = 'sudoid'  
elseif DevHid:sismember(Twix..'Hid:SecondSudo:', user_id) then
var = 'secondsudo' 
elseif DevHid:sismember(Twix..'Hid:SudoBot:', user_id) then
var = 'sudobot'  
elseif DevHid:sismember(Twix..'Hid:HidConstructor:'..chat_id, user_id) then
var = 'Hidconstructor'
elseif DevHid:sismember(Twix..'Hid:BasicConstructor:'..chat_id, user_id) then
var = 'basicconstructor'
elseif DevHid:sismember(Twix..'Hid:Constructor:'..chat_id, user_id) then
var = 'constructor'
elseif DevHid:sismember(Twix..'Hid:Managers:'..chat_id, user_id) then
var = 'manager'  
else  
var = 'No'
end  
return var
end 
--     Source Twix     --
local function Filters(msg, value)
local Hid = (Twix..'Hid:Filters:'..msg.chat_id_)
if Hid then
local names = DevHid:hkeys(Hid)
local value = value:gsub(' ','')
for i=1, #names do
if string.match(value:lower(), names[i]:lower()) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
function ReplyStatus(msg,user_id,status,text)
tdcli_function ({ID = "GetUser",user_id_ = user_id},function(arg,dp) 
if dp.first_name_ ~= false then
local UserName = (dp.username_ or "x_xxax")
for gmatch in string.gmatch(dp.first_name_, "[^%s]+") do
dp.first_name_ = gmatch
end
if status == "WrongWay" then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ عذرا عزيزي 𓄂 ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
if status == "Reply" then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ العضو 𓄂 ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
if status == "ReplyBy" then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ بواسطة 𓄂 ["..dp.first_name_.."](T.me/"..UserName..")".."\n"..text, 1, 'md')
return false
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ الحساب محذوف قم بالتاكد واعد المحاوله", 1, 'md')
end
end,nil)   
end
--     Source Twix     --
function GetCustomTitle(user_id,chat_id)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..chat_id..'&user_id='..user_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.status == "creator" then 
Status = "المالك"
elseif GetInfo.result.status == "administrator" then 
Status = "مشرف"
else
Status = false
end
if GetInfo.result.custom_title then 
Hid = GetInfo.result.custom_title
else 
Hid = Status
end
end
return Hid
end
function Validity(msg,user_id) 
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..user_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.status == "creator" then
send(msg.chat_id_,msg.id_,'⸙ ¦ مالك المجموعه')   
return false  end 
if GetInfo.result.status == "member" then
send(msg.chat_id_,msg.id_,'⸙ ¦ مجرد عضو هنا')   
return false  end
if GetInfo.result.status == 'left' then
send(msg.chat_id_,msg.id_,'⸙ ¦ الشخص غير موجود هنا')   
return false  end
if GetInfo.result.status == "administrator" then
if GetInfo.result.can_change_info == true then EDT = '✔️' else EDT = '✖️' end
if GetInfo.result.can_delete_messages == true then DEL = '✔️' else DEL = '✖️' end
if GetInfo.result.can_invite_users == true then INV = '✔️' else INV = '✖️' end
if GetInfo.result.can_pin_messages == true then PIN = '✔️' else PIN = '✖️' end
if GetInfo.result.can_restrict_members == true then BAN = '✔️' else BAN = '✖️' end
if GetInfo.result.can_promote_members == true then VIP = '✔️' else VIP = '✖️' end 
send(msg.chat_id_,msg.id_,'⸙ ¦ صلاحيات '..GetCustomTitle(user_id,msg.chat_id_)..' هي 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ حذف الرسائل 𓄂 '..DEL..'\n⸙ ¦ دعوة المستخدمين 𓄂 '..INV..'\n⸙ ¦ حظر المستخدمين 𓄂 '..BAN..'\n⸙ ¦ تثبيت الرسائل 𓄂 '..PIN..'\n⸙ ¦ تغيير المعلومات 𓄂 '..EDT..'\n⸙ ¦ اضافة مشرفين 𓄂 '..VIP..'\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉')
end
end
end
--     Source Twix     --
function GetBio(chat_id)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChat?chat_id='..chat_id)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.bio then 
Hid = GetInfo.result.bio
else 
Hid = "لا يوجد"
end
end
return Hid
end
--     Source Twix     --
local sendRequest = function(request_id, chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, callback, extra)
tdcli_function({ ID = request_id, chat_id_ = chat_id, reply_to_message_id_ = reply_to_message_id, disable_notification_ = disable_notification, from_background_ = from_background, reply_markup_ = reply_markup, input_message_content_ = input_message_content }, callback or dl_cb, extra)
end
local sendDocument = function(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, document, caption, cb, cmd)
local input_message_content = { ID = "InputMessageDocument", document_ = getInputFile(document), caption_ = caption } sendRequest("SendMessage", chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendVoice(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, voice, duration, waveform, caption, cb, cmd)
local input_message_content = { ID = "InputMessageVoice", voice_ = getInputFile(voice), duration_ = duration or 0, waveform_ = waveform, caption_ = caption } sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendAudio(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, audio, duration, waveform, caption, cb, cmd)
local input_message_content = { ID = "InputMessageAudio", audio_ = getInputFile(audio), duration_ = duration or 0, waveform_ = waveform, caption_ = caption } sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end
local function sendVideo(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, video, duration, width, height, caption, cb, cmd)    
local input_message_content = { ID = "InputMessageVideo",      video_ = getInputFile(video),      added_sticker_file_ids_ = {},      duration_ = duration or 0,      width_ = width or 0,      height_ = height or 0,      caption_ = caption    }    sendRequest('SendMessage', chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)  
end
local sendSticker = function(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, sticker)
local input_message_content = { ID = "InputMessageSticker", sticker_ = getInputFile(sticker), width_ = 0, height_ = 0 } sendRequest("SendMessage", chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, input_message_content, cb, cmd)
end 
function formsgs(msgs) 
local MsgText = ''  
if tonumber(msgs) < 100 then 
MsgText = 'جدا ضعيف' 
elseif tonumber(msgs) < 250 then 
MsgText = 'ضعيف' 
elseif tonumber(msgs) < 500 then 
MsgText = 'غير متفاعل' 
elseif tonumber(msgs) < 750 then 
MsgText = 'متوسط' 
elseif tonumber(msgs) < 1000 then 
MsgText = 'متفاعل' 
elseif tonumber(msgs) < 2000 then 
MsgText = 'قمة التفاعل' 
elseif tonumber(msgs) < 3000 then 
MsgText = 'ملك التفاعل'  
elseif tonumber(msgs) < 4000 then 
MsgText = 'اسطورة التفاعل' 
elseif tonumber(msgs) < 5000 then 
MsgText = 'متفاعل نار' 
elseif tonumber(msgs) < 6000 then 
MsgText = 'يجدح جدح' 
elseif tonumber(msgs) < 7000 then 
MsgText = 'خيالي' 
elseif tonumber(msgs) < 8000 then 
MsgText = 'رب التفاعل' 
elseif tonumber(msgs) < 9000 then 
MsgText = 'كافر بالتفاعل' 
elseif tonumber(msgs) < 10000000000 then 
MsgText = "معلك لربك" 
end 
return MsgText
end
--     Source Twix     --
function Hidmoned(chat_id, user_id, msg_id, text, offset, length) local tt = DevHid:get(Twix..'endmsg') or '' tdcli_function ({ ID = "SendMessage", chat_id_ = chat_id, reply_to_message_id_ = msg_id, disable_notification_ = 0, from_background_ = 1, reply_markup_ = nil, input_message_content_ = { ID = "InputMessageText", text_ = text..'\n\n'..tt, disable_web_page_preview_ = 1, clear_draft_ = 0, entities_ = {[0]={ ID="MessageEntityMentionName", offset_=offset, length_=length, user_id_=user_id }, }, }, }, dl_cb, nil) end
--     Source Twix     --
function ChCheck(msg)
local var = true 
if DevHid:get(Twix.."DevHid2") then
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getchatmember?chat_id='..DevHid:get(Twix..'DevHid2')..'&user_id='..msg.sender_user_id_)
local data = json:decode(url)
if res ~= 200 or data.result.status == "left" or data.result.status == "kicked" then
var = false 
if DevHid:get(Twix..'Hid:textch:user') then
local textchuser = DevHid:get(Twix..'Hid:textch:user')
send(msg.chat_id_,msg.id_,'['..textchuser..']')
else
send(msg.chat_id_,msg.id_,"⸙ ¦ عليك الاشتراك في قناة البوت \n⸙ ¦ قناة البوت 𓄂 ["..DevHid:get(Twix..'DevHid3').."]")
end
elseif data.ok then
return var
end
else
return var
end
end
chats = {}
function tdcli_update_callback(data)
if (data.ID == "UpdateNewCallbackQuery") then
local Chat_Id2 = data.chat_id_
local MsgId2 = data.message_id_
local DataText = data.payload_.data_
local Msg_Id2 = data.message_id_/2097152/0.5
if DataText == '/delyes' and DevHid:get(Twix..'yes'..data.sender_user_id_) == 'delyes' then
DevHid:del(Twix..'yes'..data.sender_user_id_, 'delyes')
DevHid:del(Twix..'no'..data.sender_user_id_, 'delno')
if RankChecking(data.sender_user_id_, data.chat_id_) then
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ لا استطيع طرد 𓄂 "..IdRank(data.sender_user_id_, data.chat_id_)) 
return false
end
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=data.chat_id_,user_id_=data.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,da) 
if (da and da.code_ and da.code_ == 400 and da.message_ == "CHAT_ADMIN_REQUIRED") then 
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if (da and da.code_ and da.code_ == 3) then 
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ البوت ليس ادمن يرجى ترقيتي !") 
return false  
end
if da and da.code_ and da.code_ == 400 and da.message_ == "USER_ADMIN_INVALID" then 
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ لا استطيع طرد مشرفين المجموعه") 
return false  
end
if da and da.ID and da.ID == "Ok" then
ChatKick(data.chat_id_, data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ تم طردك من المجموعه") 
return false
end
end,nil)  
end
if DataText == '/delno' and DevHid:get(Twix..'no'..data.sender_user_id_) == 'delno' then
DevHid:del(Twix..'yes'..data.sender_user_id_, 'delyes')
DevHid:del(Twix..'no'..data.sender_user_id_, 'delno')
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ تم الغاء امر اطردني") 
end
--     Source Twix     --
if DataText == '/yesdel' and DevHid:get(Twix..'yesdel'..data.sender_user_id_) == 'delyes' then
DevHid:del(Twix..'yesdel'..data.sender_user_id_, 'delyes')
DevHid:del(Twix..'nodel'..data.sender_user_id_, 'delno')
if DevHid:sismember(Twix..'Hid:Constructor:'..data.chat_id_, data.sender_user_id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevHid:sismember(Twix..'Hid:Managers:'..data.chat_id_, data.sender_user_id_) then
Managers = 'المدراء • ' else Managers = '' end
if DevHid:sismember(Twix..'Hid:Admins:'..data.chat_id_, data.sender_user_id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevHid:sismember(Twix..'Hid:VipMem:'..data.chat_id_, data.sender_user_id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevHid:sismember(Twix..'Hid:Cleaner:'..data.chat_id_, data.sender_user_id_) then
cleaner = 'المنظفين • ' else cleaner = '' end
if DevHid:sismember(Twix..'User:Donky:'..data.chat_id_, data.sender_user_id_) then
donky = 'المطايه • ' else donky = '' end
if DevHid:sismember(Twix..'Hid:Constructor:'..data.chat_id_, data.sender_user_id_) or DevHid:sismember(Twix..'Hid:Managers:'..data.chat_id_, data.sender_user_id_) or DevHid:sismember(Twix..'Hid:Admins:'..data.chat_id_, data.sender_user_id_) or DevHid:sismember(Twix..'Hid:VipMem:'..data.chat_id_, data.sender_user_id_) or DevHid:sismember(Twix..'Hid:Cleaner:'..data.chat_id_, data.sender_user_id_) or DevHid:sismember(Twix..'User:Donky:'..data.chat_id_, data.sender_user_id_) then
DevHid:srem(Twix..'Hid:Constructor:'..data.chat_id_,data.sender_user_id_)
DevHid:srem(Twix..'Hid:Managers:'..data.chat_id_,data.sender_user_id_)
DevHid:srem(Twix..'Hid:Admins:'..data.chat_id_,data.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..data.chat_id_,data.sender_user_id_)
DevHid:srem(Twix..'Hid:Cleaner:'..data.chat_id_,data.sender_user_id_)
DevHid:srem(Twix..'User:Donky:'..data.chat_id_,data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ تم تنزيلك من 𓄂 ⤈\n~ ( "..constructor..''..Managers..''..admins..''..vipmem..''..cleaner..''..donky.." ) ~ \n") 
else 
if IdRank(data.sender_user_id_, data.chat_id_) == 'العضو' then
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ ليس لديك رتبه في البوت") 
else 
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ لا استطيع تنزيل 𓄂 "..IdRank(data.sender_user_id_, data.chat_id_)) 
end
end
end
if DevHid:get(Twix.."Hid:NewDev"..data.sender_user_id_) then
if DataText == '/setno' then
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ تم الغاء امر تغير المطور الاساسي") 
DevHid:del(Twix.."Hid:NewDev"..data.sender_user_id_)
return false
end
if DataText == '/setyes' then
local NewDev = DevHid:get(Twix.."Hid:NewDev"..data.sender_user_id_)
tdcli_function ({ID = "GetUser",user_id_ = NewDev},function(arg,dp) 
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ المطور الجديد 𓄂 ["..dp.first_name_.."](tg://user?id="..dp.id_..")\n⸙ ¦ تم تغير المطور الاساسي بنجاح") 
end,nil)
tdcli_function ({ID = "GetUser",user_id_ = data.sender_user_id_},function(arg,dp) 
SendText(NewDev,"⸙ ¦ بواسطة 𓄂 ["..dp.first_name_.."](tg://user?id="..dp.id_..")\n⸙ ¦ لقد اصبحت انت مطور هذا البوت",0,'md')
end,nil)
local Create = function(data, file, uglify)  
file = io.open(file, "w+")   
local serialized   
if not uglify then  
serialized = serpent.block(data, {comment = false, name = "Config"})  
else  
serialized = serpent.dump(data)  
end    
file:write(serialized)
file:close()  
end
Config = {
DevId = NewDev,
TokenBot = TokenBot,
Twix = TokenBot:match("(%d+)"),
SudoIds = {NewDev},
}
Create(Config, "./config.lua")  
DevHid:del(Twix.."Hid:NewDev"..data.sender_user_id_)
dofile('Twix.lua') 
end
end
if DataText == '/nodel' and DevHid:get(Twix..'nodel'..data.sender_user_id_) == 'delno' then
DevHid:del(Twix..'yesdel'..data.sender_user_id_, 'delyes')
DevHid:del(Twix..'nodel'..data.sender_user_id_, 'delno')
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ تم الغاء امر نزلني") 
end
if DataText == '/YesRolet' and DevHid:get(Twix.."Hid:WittingStartRolet"..data.chat_id_..data.sender_user_id_) then
local List = DevHid:smembers(Twix..'Hid:ListRolet'..data.chat_id_) 
local UserName = List[math.random(#List)]
tdcli_function ({ID="SearchPublicChat",username_ = UserName},function(arg,dp) 
DevHid:incrby(Twix..'Hid:GamesNumber'..data.chat_id_..dp.id_, 5) 
end,nil) 
DevHid:del(Twix..'Hid:ListRolet'..data.chat_id_) 
DevHid:del(Twix.."Hid:WittingStartRolet"..data.chat_id_..data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ *صاحب الحظ* 𓄂 ["..UserName.."]\n⸙ ¦ *مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*")
end
if DataText == '/NoRolet' then
DevHid:del(Twix..'Hid:ListRolet'..data.chat_id_) 
DevHid:del(Twix.."Hid:NumRolet"..data.chat_id_..data.sender_user_id_) 
DevHid:del(Twix.."Hid:WittingStartRolet"..data.chat_id_..data.sender_user_id_)
EditMsg(Chat_Id2, Msg_Id2, "⸙ ¦ تم الغاء اللعبه لاعادة اللعب ارسل الالعاب") 
end
if DataText == '/ListRolet' then
local List = DevHid:smembers(Twix..'Hid:ListRolet'..data.chat_id_) 
local Text = '⸙ ¦ قائمة الاعبين 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n' 
local Textt = '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ تم اكتمال العدد الكلي هل انت مستعد ؟'
for k, v in pairs(List) do 
Text = Text..k.."~ : [" ..v.."]\n"  
end 
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/YesRolet"},{text="لا",callback_data="/NoRolet"}}} 
return https.request("https://api.telegram.org/bot"..TokenBot..'/editMessageText?chat_id='..Chat_Id2..'&message_id='..Msg_Id2..'&text=' .. URL.escape(Text..Textt).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if DataText == '/UnTkeed' then
if DevHid:sismember(Twix..'Hid:Tkeed:'..Chat_Id2, data.sender_user_id_) then
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..Chat_Id2.."&user_id="..data.sender_user_id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevHid:srem(Twix..'Hid:Tkeed:'..Chat_Id2, data.sender_user_id_)
DeleteMessage(Chat_Id2,{[0] = MsgId2})
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("⸙ تم الغاء تقيدك من المجموعه بنجاح .")..'&show_alert=true')
else
return https.request("https://api.telegram.org/bot"..TokenBot..'/answercallbackquery?callback_query_id='..data.id_..'&text='..URL.escape("⸙ عذرا هذا الامر لكشف الروبوت وليس لك .")..'&show_alert=true')
end 
end
end
if (data.ID == "UpdateNewMessage") then
local msg = data.message_
text = msg.content_.text_ 
if text and DevHid:get(Twix.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
local NewCmmd = DevHid:get(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text)
if NewCmmd then
DevHid:del(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text)
DevHid:del(Twix.."Set:Cmd:Group:New"..msg.chat_id_)
DevHid:srem(Twix.."List:Cmd:Group:New"..msg.chat_id_,text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف الامر من المجموعه", 1, 'html')  
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لايوجد امر بهذا الاسم", 1, 'html')
end
DevHid:del(Twix.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
if text and text:match('^'..(DevHid:get(Twix..'Hid:NameBot') or "تويكس")..' ') then
data.message_.content_.text_ = data.message_.content_.text_:gsub('^'..(DevHid:get(Twix..'Hid:NameBot') or "تويكس")..' ','')
end
if data.message_.content_.text_ then
local NewCmmd = DevHid:get(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":"..data.message_.content_.text_)
if NewCmmd then
data.message_.content_.text_ = (NewCmmd or data.message_.content_.text_)
end
end
if text and DevHid:get(Twix.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
DevHid:set(Twix.."Set:Cmd:Group:New"..msg.chat_id_,text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل الامر الجديد", 1, 'html')
DevHid:del(Twix.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_)
DevHid:set(Twix.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_,"true1") 
return false
end
if text and DevHid:get(Twix.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_) == "true1" then
local NewCmd = DevHid:get(Twix.."Set:Cmd:Group:New"..msg.chat_id_)
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":"..text,NewCmd)
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الامر", 1, 'html')
DevHid:del(Twix.."Set:Cmd:Group1"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
if Constructor(msg) then
if text == "الاوامر المضافه" and ChCheck(msg) then
local List = DevHid:smembers(Twix.."List:Cmd:Group:New"..msg.chat_id_.."") 
t = "⸙ ¦ قائمة الاوامر المضافه 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
Cmds = DevHid:get(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":"..v)
if Cmds then 
t = t..""..k.."~ ("..v..") • {"..Cmds.."}\n"
else
t = t..""..k.."~ ("..v..") \n"
end
end
if #List == 0 then
t = "⸙ ¦ لاتوجد اوامر مضافه في المجموعه"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
if text == "حذف الاوامر المضافه" or text == "حذف الاوامر" or text == "مسح الاوامر المضافه" and ChCheck(msg) then
local List = DevHid:smembers(Twix.."List:Cmd:Group:New"..msg.chat_id_)
for k,v in pairs(List) do
DevHid:del(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":"..v)
DevHid:del(Twix.."List:Cmd:Group:New"..msg.chat_id_)
end
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف الاوامر المضافه في المجموعه", 1, 'html')
end
if text == "ترتيب الاوامر" then
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":ا","ايدي")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"ا")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":تك","تنزيل الكل")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"تك")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":م","رفع مميز")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"م")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":اد","رفع ادمن")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"اد")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":مد","رفع مدير")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"مد")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":من","رفع منشئ")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"من")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":اس","رفع منشئ اساسي")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"اس")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":تعط","تعطيل الايدي بالصوره")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"تعط")
DevHid:set(Twix.."Set:Cmd:Group:New1"..msg.chat_id_..":تفع","تفعيل الايدي بالصوره")
DevHid:sadd(Twix.."List:Cmd:Group:New"..msg.chat_id_,"تفع")
send(msg.chat_id_, msg.id_,"⸙ ¦ تم ترتيب الاوامر بالشكل التالي 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ ايدي 𓄂 ا\n⸙ ¦ تنزيل الكل 𓄂 تك\n⸙ ¦ رفع مميز 𓄂 م\n⸙ ¦ رفع ادمن 𓄂 اد \n⸙ ¦ رفع مدير 𓄂 مد \n⸙ ¦ رفع منشئ 𓄂 من \n⸙ ¦ رفع منشئ اساسي 𓄂 اس  \n⸙ ¦ تعطيل الايدي بالصوره 𓄂 تعط\n⸙ ¦ تفعيل الايدي بالصوره 𓄂 تفع\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉")  
end
if text == "اضف امر" or text == "اضافة امر" or text == "اضافه امر" and ChCheck(msg) then
DevHid:set(Twix.."Set:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل الامر القديم", 1, 'html')
return false
end
if text == "حذف امر" or text == "مسح امر" and ChCheck(msg) then 
DevHid:set(Twix.."Del:Cmd:Group"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل الامر الذي قمت باضافته يدويا", 1, 'html')
return false
end
end
--     Source Twix     --
if text == "الصلاحيات" or text == "صلاحيات" and ChCheck(msg) then 
local List = DevHid:smembers(Twix.."Coomds"..msg.chat_id_)
if #List == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لاتوجد صلاحيات مضافه", 1, 'html')
return false
end
t = "⸙ ¦ قائمة الصلاحيات المضافه 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
var = DevHid:get(Twix.."Comd:New:rt:Hid:"..v..msg.chat_id_)
if var then
t = t..""..k.."~ "..v.." • ("..var..")\n"
else
t = t..""..k.."~ "..v.."\n"
end
end
Dev_Hid(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
if Admin(msg) then
if text == "حذف الصلاحيات" and ChCheck(msg) or text == "مسح الصلاحيات" and ChCheck(msg) then
local List = DevHid:smembers(Twix.."Coomds"..msg.chat_id_)
for k,v in pairs(List) do
DevHid:del(Twix.."Comd:New:rt:Hid:"..v..msg.chat_id_)
DevHid:del(Twix.."Coomds"..msg.chat_id_)
end
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف الصلاحيات المضافه", 1, 'html')
end
end
if text and text:match("^اضف صلاحيه (.*)$") and ChCheck(msg) then 
ComdNew = text:match("^اضف صلاحيه (.*)$")
DevHid:set(Twix.."Comd:New:rt"..msg.chat_id_..msg.sender_user_id_,ComdNew)  
DevHid:sadd(Twix.."Coomds"..msg.chat_id_,ComdNew)  
DevHid:setex(Twix.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_,200,true)  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل نوع الصلاحيه \n{ عضو • مميز  • ادمن  • مدير }\n⸙ ¦ ارسل الغاء لالغاء الامر ", 1, 'html')
end
if text and text:match("^حذف صلاحيه (.*)$") and ChCheck(msg) or text and text:match("^مسح صلاحيه (.*)$") and ChCheck(msg) then 
ComdNew = text:match("^حذف صلاحيه (.*)$") or text:match("^مسح صلاحيه (.*)$")
DevHid:del(Twix.."Comd:New:rt:Hid:"..ComdNew..msg.chat_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف الصلاحيه", 1, 'html')
end
if DevHid:get(Twix.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء الامر", 1, 'html')
DevHid:del(Twix.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
if text == "مدير" then
if not Constructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تستطيع اضافة صلاحية ( عضو • مميز  • ادمن )\n⸙ ¦ ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "ادمن" then
if not Manager(msg) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تستطيع اضافة صلاحية ( عضو • مميز )\n⸙ ¦ ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "مميز" then
if not Admin(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تستطيع اضافة صلاحية ( عضو )\n⸙ ¦ ارسال نوع الصلاحيه مره اخرى", 1, 'html')
return false
end
end
if text == "مدير" or text == "ادمن" or text == "مميز" or text == "عضو" then
local textn = DevHid:get(Twix.."Comd:New:rt"..msg.chat_id_..msg.sender_user_id_)  
DevHid:set(Twix.."Comd:New:rt:Hid:"..textn..msg.chat_id_,text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اضافة الصلاحيه", 1, 'html')
DevHid:del(Twix.."Comd:New"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
end

if text and text:match("رفع (.*)") and tonumber(msg.reply_to_message_id_) > 0 then 
local DEV_ABBAS = text:match("رفع (.*)")
if DevHid:sismember(Twix.."Coomds"..msg.chat_id_,DEV_ABBAS) then
function by_reply(extra, result, success)   
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local mrHid = DevHid:get(Twix.."Comd:New:rt:Hid:"..DEV_ABBAS..msg.chat_id_)
if mrHid == "مميز" and VipMem(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevHid:set(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_ABBAS) 
DevHid:sadd(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
elseif mrHid == "ادمن" and Admin(msg) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevHid:set(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_ABBAS)
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
elseif mrHid == "مدير" and Manager(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevHid:set(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_,DEV_ABBAS)  
DevHid:sadd(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
elseif mrHid == "عضو" then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
end
end,nil)   
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
if text and text:match("تنزيل (.*)") and tonumber(msg.reply_to_message_id_) > 0 then 
local DEV_ABBAS = text:match("تنزيل (.*)")
if DevHid:sismember(Twix.."Coomds"..msg.chat_id_,DEV_ABBAS) then
function by_reply(extra, result, success)   
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local mrHid = DevHid:get(Twix.."Comd:New:rt:Hid:"..DEV_ABBAS..msg.chat_id_)
if mrHid == "مميز" and VipMem(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevHid:del(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrHid == "ادمن" and Admin(msg) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:del(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrHid == "مدير" and Manager(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
DevHid:del(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.sender_user_id_)
elseif mrHid == "عضو" then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..data.first_name_..'](t.me/'..(data.username_ or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..DEV_ABBAS..' ❩ بنجاح', 1, 'md')
end
end,nil)   
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
if text and text:match("^رفع (.*) @(.*)") then 
local text1 = {string.match(text, "^(رفع) (.*) @(.*)$")}
if DevHid:sismember(Twix.."Coomds"..msg.chat_id_,text1[2]) then
function py_username(extra, result, success)   
if result.id_ then
local mrHid = DevHid:get(Twix.."Comd:New:rt:Hid:"..text1[2]..msg.chat_id_)
if mrHid == "مميز" and VipMem(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevHid:sadd(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:set(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrHid == "ادمن" and Admin(msg) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:set(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrHid == "مدير" and Manager(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevHid:sadd(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
DevHid:set(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.id_,text1[2])
elseif mrHid == "عضو" then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم رفعه ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *المعرف غير صحيح*", 1, 'md')
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},py_username,nil) 
end 
end
if text and text:match("^تنزيل (.*) @(.*)") then 
local text1 = {string.match(text, "^(تنزيل) (.*) @(.*)$")}
if DevHid:sismember(Twix.."Coomds"..msg.chat_id_,text1[2]) then
function py_username(extra, result, success)   
if result.id_ then
local mrHid = DevHid:get(Twix.."Comd:New:rt:Hid:"..text1[2]..msg.chat_id_)
if mrHid == "مميز" and VipMem(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:del(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrHid == "ادمن" and Admin(msg) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:del(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrHid == "مدير" and Manager(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
DevHid:del(Twix.."Comd:New:rt:User:"..msg.chat_id_..result.id_)
elseif mrHid == "عضو" then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو 𓄂 ❨ ['..result.title_..'](t.me/'..(text1[3] or 'x_xxax')..')'..' ❩\n⸙ ¦ تم تنزيله ❨ '..text1[2]..' ❩ بنجاح', 1, 'md')
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *المعرف غير صحيح*", 1, 'md')
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},py_username,nil) 
end  
end
--     Source Twix     --
if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match("-100(%d+)") then
DevHid:incr(Twix..'Hid:UsersMsgs'..Twix..os.date('%d')..':'..msg.chat_id_..':'..msg.sender_user_id_)
DevHid:incr(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
DevHid:incr(Twix..'Hid:MsgNumberDay'..msg.chat_id_..':'..os.date('%d'))  
ChatType = 'sp' 
elseif id:match("^(%d+)") then
if not DevHid:sismember(Twix.."Hid:Users",msg.chat_id_) then
DevHid:sadd(Twix.."Hid:Users",msg.chat_id_)
end
ChatType = 'pv' 
else
ChatType = 'gp' 
end
end 
--     Source Twix     --
if ChatType == 'pv' then 
if text == '/start' or text == 'رجوع ،🔙‘' then 
if SecondSudo(msg) then 
local Sudo_Welcome = '⸙ ¦ مرحبا عزيزي المطور \n⸙ ¦ انت المطور الاساسي هنا \n⸙ ¦ اليك ازرار سورس تويكس \n⸙ ¦ تستطيع التحكم بكل الاوامر فقط اضغط على الامر الذي تريد تنفيذه'
local key = {
{'وضع اسم البوت','𓄂 تحديث ⸙','وضع كليشه المطور'},
{'𓄂 المطورين ⸙','𓄂 الاحصائيات ⸙'},
{'𓄂 المجموعات ⸙','روابط الكروبات','𓄂 المشتركين ⸙'},
{'𓄂 تعطيل التواصل ⸙','𓄂 تفعيل التواصل ⸙'},
{'تنظيف الكروبات','𓄂 قائمه العام ⸙','تنظيف المشتركين'},
{'𓄂 تغير المطور الاساسي ⸙'},
{'تعطيل ترحيب البوت','تفعيل ترحيب البوت'},
{'𓄂 تغير معلومات الترحيب ⸙'},
{'𓄂 تعطيل المغادره ⸙','𓄂 تفعيل المغادره ⸙'},
{'𓄂 تعطيل الاذاعه ⸙','𓄂 تفعيل الاذاعه ⸙'},
{'𓄂 اذاعه بالتثبيت ⸙'},
{'𓄂 اذاعه عام ⸙','𓄂 اذاعه خاص ⸙'},
{'𓄂 اذاعه عام بالتوجيه ⸙','𓄂 اذاعه خاص بالتوجيه ⸙'},
{'~ تعيين كلايش الاوامر ⸙'},
{'تعطيل البوت الخدمي','تفعيل البوت الخدمي'},
{'جلب نسخه السورس','تحديث السورس','جلب نسخه الكروبات'},
{'𓄂 حذف رد عام ⸙','𓄂 الردود العام ⸙','𓄂 اضف رد عام ⸙'},
{'𓄂 حذف رد الخاص ⸙','𓄂 تعيين رد الخاص ⸙'},
{'حذف قناة الاشتراك','قناة الاشتراك','تعيين قناة الاشتراك'},
{'حذف كليشه الاشتراك','كليشه الاشتراك','تغير كليشه الاشتراك'},
}
SendInline(msg.chat_id_,Sudo_Welcome,key)
return false
end end
if text == '~ تعيين كلايش الاوامر ~' then 
if SecondSudo(msg) then 
local Sudo_Welcome = '⸙ ¦ اهلا بك مجددا عزيزي المطور \n⸙ ¦ اليك الازرار الخاصه بتعديل وتغيير كلايش سورس تويكس فقط اضغط على الامر الذي تريد تنفيذه'
local key = {
{'حذف كليشة الايدي','تعيين كليشة الايدي'},
{'تعيين امر الاوامر'},
{'تعيين امر م3','تعيين امر م2','تعيين امر م1'},
{'تعيين امر م6','تعيين امر م5','تعيين امر م4'},
{'استعادة كلايش الاوامر'},
{'رجوع ،🔙‘'},
}
SendInline(msg.chat_id_,Sudo_Welcome,key)
return false
end end
if text == '/start' and ChCheck(msg) then  
if not DevHid:get(Twix..'Hid:Start:Time'..msg.sender_user_id_) then
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,dp) 
local inline = {{{text="⸙ المطور .",url="t.me/"..(dp.username_ or "x_xxax")}}}
local start = DevHid:get(Twix.."Hid:Start:Bot")
if start then 
Start_Source = start
else
Start_Source = "⸙ ¦ مرحبا انا بوت اسمي "..NameBot.."\n⸙ ¦ اختصاصي حماية المجموعات\n⸙ ¦ من التفليش والسبام والخخ .. . ،\n⸙ ¦ تفعيلي سهل ومجانا فقط قم برفعي ادمن في مجموعتك وارسل امر 𓄂 تفعيل\n⸙ ¦ سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
SendInline(msg.chat_id_,Start_Source,nil,inline)
end,nil)
end
DevHid:setex(Twix..'Hid:Start:Time'..msg.sender_user_id_,300,true)
return false
end 
--     Source Twix     --
if not SecondSudo(msg) and not DevHid:sismember(Twix..'Hid:Ban:Pv',msg.sender_user_id_) and not DevHid:get(Twix..'Hid:Texting:Pv') then
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,chat) 
Dev_Hid(msg.sender_user_id_, msg.id_, 1, '⸙ ¦ تم ارسال رسالتك الى [المطور](t.me/'..(chat.username_ or "x_xxax")..')', 1, 'md') 
tdcli_function({ID="ForwardMessages",chat_id_=DevId,from_chat_id_= msg.sender_user_id_,message_ids_={[0]=msg.id_},disable_notification_=1,from_background_=1},function(arg,data) 
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(arg,dp) 
if data and data.messages_ and data.messages_[0] ~= false and data.ID ~= "Error" then
if data and data.messages_ and data.messages_[0].content_.sticker_ then
SendText(DevId,'⸙ ¦ تم ارسال الملصق من 𓄂 ⤈\n['..string.sub(dp.first_name_,0, 40)..'](tg://user?id='..dp.id_..')',0,'md') 
return false
end;end;end,nil);end,nil);end,nil);end
if SecondSudo(msg) and msg.reply_to_message_id_ ~= 0  then    
tdcli_function({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)},function(extra, result, success) 
if result.forward_info_.sender_user_id_ then     
id_user = result.forward_info_.sender_user_id_    
end 
tdcli_function ({ID = "GetUser",user_id_ = id_user},function(arg,data) 
if text == 'حظر' or text == 'حضر' then
local Text = '⸙ ¦ العضو 𓄂 ['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')'..'\n⸙ ¦ تم حظره من التواصل'
SendText(DevId,Text,msg.id_/2097152/0.5,'md') 
DevHid:sadd(Twix..'Hid:Ban:Pv',data.id_)  
return false  
end 
if text == 'الغاء الحظر' or text == 'الغاء حظر' then
local Text = '⸙ ¦ العضو 𓄂 ['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')'..'\n⸙ ¦ تم الغاء حظره من التواصل'
SendText(DevId,Text,msg.id_/2097152/0.5,'md') 
DevHid:srem(Twix..'Hid:Ban:Pv',data.id_)  
return false  
end 
tdcli_function({ID='GetChat',chat_id_ = id_user},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",chat_id_ = id_user, action_ = {  ID = "SendMessageTypingAction", progress_ = 100} },function(arg,dp) 
if dp.code_ == 400 or dp.code_ == 5 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو قام بحظر البوت لا تستطيع ارسال الرسائل له', 1, 'md')
return false  
end 
if text then
Dev_Hid(id_user, 0, 1, text, 1, "md")  
Text = '⸙ ¦ تم ارسال الرساله الى 𓄂 ⤈'
elseif msg.content_.ID == 'MessageSticker' then    
sendSticker(id_user, msg.id_, 0, 1,nil, msg.content_.sticker_.sticker_.persistent_id_)   
Text = '⸙ ¦ تم ارسال الملصق الى 𓄂 ⤈'
elseif msg.content_.ID == 'MessagePhoto' then    
sendPhoto(id_user, msg.id_, 0, 1,nil, msg.content_.photo_.sizes_[0].photo_.persistent_id_,(msg.content_.caption_ or ''))    
Text = '⸙ ¦ تم ارسال الصوره الى 𓄂 ⤈'
elseif msg.content_.ID == 'MessageAnimation' then    
sendDocument(id_user, msg.id_, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_)    
Text = '⸙ ¦ تم ارسال المتحركه الى 𓄂 ⤈'
elseif msg.content_.ID == 'MessageVoice' then    
sendVoice(id_user, msg.id_, 0, 1,nil, msg.content_.voice_.voice_.persistent_id_)    
Text = '⸙ ¦ تم ارسال البصمه الى 𓄂 ⤈'
end     
SendText(DevId, Text..'\n'..'['..string.sub(data.first_name_,0, 40)..'](tg://user?id='..data.id_..')',0,'md') 
end,nil);
end,nil);
end,nil);
end,nil);
end 
end 
--     Source Twix     --
if text and DevHid:get(Twix..'Hid:Start:Bots'..msg.sender_user_id_) then
if text == 'الغاء' then   
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء حفظ كليشة الستارت', 1, 'md')
DevHid:del(Twix..'Hid:Start:Bots'..msg.sender_user_id_) 
return false
end
DevHid:set(Twix.."Hid:Start:Bot",text)  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ كليشة الستارت', 1, 'md')
DevHid:del(Twix..'Hid:Start:Bots'..msg.sender_user_id_) 
return false
end
if SecondSudo(msg) then
if text == 'تعيين رد الخاص' or text == 'ضع كليشه ستارت' or text == '𓄂 تعيين رد الخاص ⸙' then 
DevHid:set(Twix..'Hid:Start:Bots'..msg.sender_user_id_,true) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل لي كليشة الستارت الان', 1, 'md')
return false
end
if text == 'حذف رد الخاص' or text == 'حذف كليشه ستارت' or text == '𓄂 حذف رد الخاص ⸙' then 
DevHid:del(Twix..'Start:Bot') 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حذف كليشة الستارت بنجاح', 1, 'md')
end
if text == 'جلب رد الخاص' then  
local start = DevHid:get(Twix.."Hid:Start:Bot")
if start then 
Start_Source = start
else
Start_Source = "⸙ ¦ مرحبا انا بوت اسمي "..NameBot.."\n⸙ ¦ اختصاصي حماية المجموعات\n⸙ ¦ من التفليش والسبام والخخ .. . ،\n⸙ ¦ تفعيلي سهل ومجانا فقط قم برفعي ادمن في مجموعتك وارسل امر 𓄂 تفعيل\n⸙ ¦ سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
Dev_Hid(msg.chat_id_, msg.id_, 1, Start_Source, 1, 'md')
return false
end
if text == 'تفعيل التواصل' or text == '𓄂 تفعيل التواصل ⸙' then   
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل التواصل بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Texting:Pv') 
end
if text == 'تعطيل التواصل' or text == '𓄂 تعطيل التواصل ⸙' then  
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل التواصل بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Texting:Pv',true) 
end
end
--     Source Twix     --
function getUser(user_id, cb)
tdcli_function ({
ID = "GetUser",
user_id_ = user_id
}, cb, nil)
end
local msg = data.message_
text = msg.content_.text_
if msg.content_.ID == "MessageChatAddMembers" then 
DevHid:incr(Twix..'Hid:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)
DevHid:set(Twix.."Who:Added:Me"..msg.chat_id_..':'..msg.content_.members_[0].id_,msg.sender_user_id_)
local mem_id = msg.content_.members_  
local Bots = DevHid:get(Twix.."Hid:Lock:Bots"..msg.chat_id_) 
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "kick" and not VipMem(msg) then   
https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..msg.sender_user_id_)
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "del" and not VipMem(msg) then   
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and Bots == "ked" and not VipMem(msg) then
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" .. msg.sender_user_id_ .. "&can_send_messages=false&can_send_media_messages=false&can_send_other_messages=false&can_add_web_page_previews=false")
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, msg.sender_user_id_)
GetInfo = https.request("https://api.telegram.org/bot"..TokenBot.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local JsonInfo = JSON.decode(GetInfo)
if JsonInfo.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) 
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp) local admins = dp.members_ for i=0 , #admins do if dp.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not VipMem(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end  
end  
end
if msg.content_.ID == "MessageChatDeleteMember" and tonumber(msg.content_.user_.id_) == tonumber(Twix) then 
DevHid:srem(Twix.."Hid:Groups", msg.chat_id_) 
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
if not Sudo(msg) then
SendText(DevId,"⸙ ¦ تم طرد البوت من المجموعه 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ بواسطة 𓄂 "..Name.."\n⸙ ¦ اسم المجموعه 𓄂 ["..NameChat.."]\n⸙ ¦ ايدي المجموعه 𓄂 ⤈ \n❨ `"..msg.chat_id_.."` ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الوقت 𓄂 "..os.date("%I:%M%p").."\n⸙ ¦ التاريخ 𓄂 "..os.date("%Y/%m/%d").."",0,'md')
end
end,nil)
end,nil)
end
if msg.content_.ID == "MessageChatDeletePhoto" or msg.content_.ID == "MessageChatChangePhoto" or msg.content_.ID == 'MessagePinMessage' or msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == 'MessageChatChangeTitle' or msg.content_.ID == "MessageChatDeleteMember" then   
if DevHid:get(Twix..'Hid:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})    
end   
end
if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" then   
DevHid:incr(Twix..'Hid:EntryNumber'..msg.chat_id_..':'..os.date('%d'))  
elseif msg.content_.ID == "MessageChatDeleteMember" then   
DevHid:incr(Twix..'Hid:ExitNumber'..msg.chat_id_..':'..os.date('%d'))  
end
--     Source Twix     --
if text ==('تفعيل') and not SudoBot(msg) and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:FreeBot'..Twix) then
if ChatType == 'pv' then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لاتستطيع تفعيلي هنا يرجى اضافتي في مجموعه اولا', 1, 'md')
return false
end
if ChatType ~= 'sp' then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي', 1, 'md')
return false
end
if msg.can_be_deleted_ == false then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ البوت ليس ادمن يرجى ترقيتي !', 1, 'md')
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,ChatMem) 
if ChatMem and ChatMem.status_.ID == "ChatMemberStatusEditor" or ChatMem and ChatMem.status_.ID == "ChatMemberStatusCreator" then
if ChatMem and ChatMem.user_id_ == msg.sender_user_id_ then
if ChatMem.status_.ID == "ChatMemberStatusCreator" then
status = 'منشئ'
elseif ChatMem.status_.ID == "ChatMemberStatusEditor" then
status = 'ادمن'
else 
status = 'عضو'
end
DevHid:del(Twix..'Hid:HidConstructor:'..msg.chat_id_)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,abbas) 
local admins = abbas.members_
for i=0 , #admins do
if abbas.members_[i].bot_info_ == false and abbas.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)
end
end,nil)   
else
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)
end
if abbas.members_[i].status_.ID == "ChatMemberStatusCreator" then
DevHid:sadd(Twix.."Hid:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevHid:sadd(Twix.."Hid:HidConstructor:"..msg.chat_id_,admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevHid:srem(Twix.."Hid:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevHid:srem(Twix.."Hid:HidConstructor:"..msg.chat_id_,admins[i].user_id_)
end
end,nil)  
end 
end
end,nil)
if DevHid:sismember(Twix..'Hid:Groups',msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المجموعه بالتاكيد مفعله', 1, 'md')
else
if tonumber(data.member_count_) < tonumber(DevHid:get(Twix..'Hid:Num:Add:Bot') or 0) and not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عدد اعضاء المجموعه اقل من 𓄂 *'..(DevHid:get(Twix..'Hid:Num:Add:Bot') or 0)..'* عضو', 1, 'md')
return false
end
ReplyStatus(msg,result.id_,"ReplyBy","⸙ ¦ تم تفعيل المجموعه "..dp.title_)  
DevHid:sadd(Twix.."Hid:Groups",msg.chat_id_)
DevHid:sadd(Twix..'Hid:BasicConstructor:'..msg.chat_id_,msg.sender_user_id_)
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NumMem = data.member_count_
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevHid:set(Twix.."Hid:Groups:Links"..msg.chat_id_,LinkGroup) 
SendText(DevId,"⸙ ¦ تم تفعيل مجموعه جديده 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ بواسطة 𓄂 "..Name.."\n⸙ ¦ موقعه في المجموعه 𓄂 "..status.."\n⸙ ¦ اسم المجموعه 𓄂 ["..NameChat.."]\n⸙ ¦ عدد اعضاء المجموعه 𓄂 ❨ *"..NumMem.."* ❩\n⸙ ¦ ايدي المجموعه 𓄂 ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⸙ ¦ رابط المجموعه 𓄂 ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الوقت 𓄂 "..os.date("%I:%M%p").."\n⸙ ¦ التاريخ 𓄂 "..os.date("%Y/%m/%d").."",0,'md')
end
end end
end,nil)
end,nil)
end,nil)
end,nil)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع تفعيل هذه المجموعه بسبب تعطيل البوت الخدمي من قبل المطور الاساسي', 1, 'md') 
end 
end 
--     Source Twix     --
if msg.date_ and msg.date_ < tonumber(os.time() - 30) then
print("*( OLD MESSAGE )*")
return false
end
--     Source Twix     --
tdcli_function({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,data) 
if data.username_ ~= false then
DevHid:set(Twix..'Save:UserName'..msg.sender_user_id_,data.username_)
end;end,nil) 
--     Source Twix     --
local ReFalse = tostring(msg.chat_id_)
if not DevHid:sismember(Twix.."Hid:Groups",msg.chat_id_) and not ReFalse:match("^(%d+)") and not SudoBot(msg) then
print("Return False : The Bot Is Not Enabled In The Group")
return false
end
--     Source Twix     --
-------- MSG TYPES ---------
if msg.content_.ID == "MessageChatJoinByLink" and not VipMem(msg) then 
if DevHid:get(Twix..'Hid:Lock:Robot'..msg.chat_id_) then
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(arg,dp) 
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..dp.id_)
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, dp.id_)
local Text = '⸙ ¦ بواسطه‍ 𓄂 ['..string.sub(dp.first_name_,0, 40)..'](tg://user?id='..dp.id_..')\n⸙ ¦ يجب علينا التأكد أنك لست روبوت\n⸙ ¦ تم تقيدك اضغط الزر بالاسفل لفكه'
keyboard = {} 
keyboard.inline_keyboard = {{{text="اضغط هنا لفك تقيدك",callback_data="/UnTkeed"}}} 
Msg_id = msg.id_/2097152/0.5
HTTPS.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id='..msg.chat_id_..'&text='..URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil)
return false
end
if DevHid:get(Twix.."Hid:Lock:Join"..msg.chat_id_) then
ChatKick(msg.chat_id_,msg.sender_user_id_) 
return false  
end
end
if msg.content_.ID == "MessagePhoto" then
if not Manager(msg) then 
local filter = DevHid:smembers(Twix.."Hid:FilterPhoto"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.photo_.id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⸙ ¦ الصوره التي ارسلتها تم منعها من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})       
return false   
end
end
end
end
if msg.content_.ID == "MessageAnimation" then
if not Manager(msg) then 
local filter = DevHid:smembers(Twix.."Hid:FilterAnimation"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.animation_.animation_.persistent_id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⸙ ¦ المتحركه التي ارسلتها تم منعها من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})       
return false   
end
end
end
end
if msg.content_.ID == "MessageSticker" then
if not Manager(msg) then 
local filter = DevHid:smembers(Twix.."Hid:FilterSteckr"..msg.chat_id_)
for k,v in pairs(filter) do
if v == msg.content_.sticker_.sticker_.persistent_id_ then
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⸙ ¦ الملصق الذي ارسلته تم منعه من المجموعه")  
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false   
end
end
end
end
--     Source Twix     --
if text and text:match("^(.*)$") then
local DelGpRed = DevHid:get(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if DelGpRed == 'DelGpRed' then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ الكلمه 𓄂 '..msg.content_.text_..' تم حذفها',  1, "html")
DevHid:del(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
DevHid:srem(Twix..'Hid:Manager:GpRed'..msg.chat_id_..'',msg.content_.text_)
return false
end
end
if text and text:match("^(.*)$") then
local DelAllRed = DevHid:get(Twix.."Hid:Add:AllRed"..msg.sender_user_id_)
if DelAllRed == 'DelAllRed' then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ الكلمه 𓄂 '..msg.content_.text_..' تم حذفها',  1, "html")
DevHid:del(Twix.."Hid:Add:AllRed"..msg.sender_user_id_)
DevHid:del(Twix.."Hid:Gif:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:Voice:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:Audio:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:Photo:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:Stecker:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:Video:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:File:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:Text:AllRed"..msg.content_.text_)
DevHid:del(Twix.."Hid:Sudo:AllRed",msg.content_.text_)
return false
end
end
--     Source Twix     --
if msg.content_.text_ or msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.audio_ or msg.content_.photo_ or msg.content_.animation_ then 
local SaveGpRed = DevHid:get(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if SaveGpRed == 'SaveGpRed' then 
if text == 'الغاء' then
local DelManagerRep = DevHid:get(Twix..'DelManagerRep'..msg.chat_id_..'')
DevHid:srem(Twix..'Hid:Manager:GpRed'..msg.chat_id_..'',DelManagerRep)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء حفظ الرد', 1, 'md')
DevHid:del(Twix..'Hid:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
DevHid:del(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_)
DevHid:del(Twix..'DelManagerRep'..msg.chat_id_..'')
return false
end
DevHid:del(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
local SaveGpRed = DevHid:get(Twix..'Hid:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
if msg.content_.video_ then DevHid:set(Twix..'Hid:Video:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.video_.video_.persistent_id_)
end
if msg.content_.document_ then DevHid:set(Twix..'Hid:File:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.document_.document_.persistent_id_)
end
if msg.content_.sticker_ then DevHid:set(Twix..'Hid:Stecker:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.sticker_.sticker_.persistent_id_) 
end 
if msg.content_.voice_ then DevHid:set(Twix..'Hid:Voice:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.voice_.voice_.persistent_id_) 
end
if msg.content_.audio_ then DevHid:set(Twix..'Hid:Audio:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.audio_.audio_.persistent_id_) 
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_group = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_group = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_group = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_group = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
DevHid:set(Twix..'Hid:Photo:GpRed'..SaveGpRed..''..msg.chat_id_..'', photo_in_group) 
end
if msg.content_.animation_ then DevHid:set(Twix..'Hid:Gif:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.animation_.animation_.persistent_id_) 
end 
if msg.content_.text_ then
DevHid:set(Twix..'Hid:Text:GpRed'..SaveGpRed..''..msg.chat_id_..'', msg.content_.text_)
end 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ الرد الجديد', 1, 'md') 
DevHid:del(Twix..'Hid:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'')
DevHid:del(Twix..'DelManagerRep'..msg.chat_id_..'')
return false 
end 
end
if msg.content_.text_ and not DevHid:get(Twix..'Hid:Lock:GpRed'..msg.chat_id_) then 
if DevHid:get(Twix..'Hid:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendVideo(msg.chat_id_, msg.id_, 0, 1,nil, DevHid:get(Twix..'Hid:Video:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevHid:get(Twix..'Hid:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendDocument(msg.chat_id_, msg.id_, 0, 1,nil, DevHid:get(Twix..'Hid:File:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevHid:get(Twix..'Hid:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendVoice(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix..'Hid:Voice:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevHid:get(Twix..'Hid:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendAudio(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix..'Hid:Audio:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevHid:get(Twix..'Hid:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix..'Hid:Photo:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end
if DevHid:get(Twix..'Hid:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix..'Hid:Gif:GpRed'..msg.content_.text_..''..msg.chat_id_..'')) 
end 
if DevHid:get(Twix..'Hid:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then 
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, DevHid:get(Twix..'Hid:Stecker:GpRed'..msg.content_.text_..''..msg.chat_id_..''))
end
if DevHid:get(Twix..'Hid:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'') then
function HidTwixTEAM(extra,result,success)
if result.username_ then username = '[@'..result.username_..']' else username = 'لا يوجد' end
local edit_msg = DevHid:get(Twix..'Hid:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local Text = DevHid:get(Twix..'Hid:Text:GpRed'..msg.content_.text_..''..msg.chat_id_..'')
local Text = Text:gsub('#username',(username or 'لا يوجد')) 
local Text = Text:gsub('#name','['..result.first_name_..']')
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',edit_msg)
local Text = Text:gsub('#msgs',(user_msgs or 'لا يوجد'))
local Text = Text:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
send(msg.chat_id_,msg.id_,Text)
end
getUser(msg.sender_user_id_, HidTwixTEAM)
end
end
--     Source Twix     --
text = msg.content_.text_
if msg.content_.text_ or msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.audio_ or msg.content_.photo_ or msg.content_.animation_ then
local SaveAllRed = DevHid:get(Twix.."Hid:Add:AllRed"..msg.sender_user_id_)
if SaveAllRed == 'SaveAllRed' then
if text == 'الغاء' then
local DelSudoRep = DevHid:get(Twix..'DelSudoRep')
DevHid:del(Twix.."Hid:Sudo:AllRed",DelSudoRep)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء حفظ الرد', 1, 'md')
DevHid:del(Twix.."Hid:Add:AllText"..msg.sender_user_id_)
DevHid:del(Twix.."Hid:Add:AllRed"..msg.sender_user_id_)
DevHid:del(Twix.."DelSudoRep")
return false
end
DevHid:del(Twix.."Hid:Add:AllRed"..msg.sender_user_id_)
local SaveAllRed = DevHid:get(Twix.."Hid:Add:AllText"..msg.sender_user_id_)
if msg.content_.video_ then
DevHid:set(Twix.."Hid:Video:AllRed"..SaveAllRed, msg.content_.video_.video_.persistent_id_)
end
if msg.content_.document_ then
DevHid:set(Twix.."Hid:File:AllRed"..SaveAllRed, msg.content_.document_.document_.persistent_id_)
end
if msg.content_.sticker_ then
DevHid:set(Twix.."Hid:Stecker:AllRed"..SaveAllRed, msg.content_.sticker_.sticker_.persistent_id_)
end
if msg.content_.voice_ then
DevHid:set(Twix.."Hid:Voice:AllRed"..SaveAllRed, msg.content_.voice_.voice_.persistent_id_)
end
if msg.content_.audio_ then
DevHid:set(Twix.."Hid:Audio:AllRed"..SaveAllRed, msg.content_.audio_.audio_.persistent_id_)
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_all_groups = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_all_groups = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_all_groups = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_all_groups = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
DevHid:set(Twix.."Hid:Photo:AllRed"..SaveAllRed, photo_in_all_groups)
end
if msg.content_.animation_ then
DevHid:set(Twix.."Hid:Gif:AllRed"..SaveAllRed, msg.content_.animation_.animation_.persistent_id_)
end
if msg.content_.text_ then
DevHid:set(Twix.."Hid:Text:AllRed"..SaveAllRed, msg.content_.text_)
end 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ الرد الجديد', 1, 'md') 
DevHid:del(Twix.."Hid:Add:AllText"..msg.sender_user_id_)
DevHid:del(Twix..'DelSudoRep')
return false end end
if msg.content_.text_ and not DevHid:get(Twix..'Hid:Lock:AllRed'..msg.chat_id_) then
if DevHid:get(Twix.."Hid:Video:AllRed"..msg.content_.text_) then
sendVideo(msg.chat_id_, msg.id_, 0, 1,nil, DevHid:get(Twix.."Hid:Video:AllRed"..msg.content_.text_))
end
if DevHid:get(Twix.."Hid:File:AllRed"..msg.content_.text_) then
sendDocument(msg.chat_id_, msg.id_, 0, 1,nil, DevHid:get(Twix.."Hid:File:AllRed"..msg.content_.text_))
end
if DevHid:get(Twix.."Hid:Voice:AllRed"..msg.content_.text_)  then
sendVoice(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix.."Hid:Voice:AllRed"..msg.content_.text_))
end
if DevHid:get(Twix.."Hid:Audio:AllRed"..msg.content_.text_)  then
sendAudio(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix.."Hid:Audio:AllRed"..msg.content_.text_))
end
if DevHid:get(Twix.."Hid:Photo:AllRed"..msg.content_.text_)  then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix.."Hid:Photo:AllRed"..msg.content_.text_))
end
if  DevHid:get(Twix.."Hid:Gif:AllRed"..msg.content_.text_) then
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, DevHid:get(Twix.."Hid:Gif:AllRed"..msg.content_.text_))
end
if DevHid:get(Twix.."Hid:Stecker:AllRed"..msg.content_.text_) then
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, DevHid:get(Twix.."Hid:Stecker:AllRed"..msg.content_.text_))
end
if DevHid:get(Twix.."Hid:Text:AllRed"..msg.content_.text_) then
function HidTwixTEAM(extra,result,success)
if result.username_ then username = '[@'..result.username_..']' else username = 'لا يوجد' end
local edit_msg = DevHid:get(Twix..'Hid:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local Text = DevHid:get(Twix.."Hid:Text:AllRed"..msg.content_.text_)
local Text = Text:gsub('#username',(username or 'لا يوجد')) 
local Text = Text:gsub('#name','['..result.first_name_..']')
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',edit_msg)
local Text = Text:gsub('#msgs',(user_msgs or 'لا يوجد'))
local Text = Text:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
send(msg.chat_id_,msg.id_,Text)
end
getUser(msg.sender_user_id_, HidTwixTEAM)
end
end 
--     Source Twix     --
--       Spam Send        --
function NotSpam(msg,Type)
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,dp) 
local GetName = '['..dp.first_name_..'](tg://user?id='..dp.id_..')'
if Type == "kick" then 
ChatKick(msg.chat_id_,msg.sender_user_id_) 
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '⸙ ¦ العضو 𓄂 '..GetName..' \n⸙ ¦ قام بالتكرار المحدد تم طرده '
SendText(msg.chat_id_,Text,0,'md')
return false  
end 
if Type == "del" then 
DeleteMessage(msg.chat_id_,{[0] = msg.id_})   
return false  
end 
if Type == "keed" and not DevHid:sismember(Twix..'Hid:Tkeed:'..msg.chat_id_, msg.sender_user_id_) then
https.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..msg.sender_user_id_.."") 
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, msg.sender_user_id_)
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '⸙ ¦ العضو 𓄂 '..GetName..' \n⸙ ¦ قام بالتكرار المحدد تم تقيده '
SendText(msg.chat_id_,Text,0,'md')
return false  
end  
if Type == "mute" and not DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_, msg.sender_user_id_) then
DevHid:sadd(Twix..'Hid:Muted:'..msg.chat_id_,msg.sender_user_id_)
my_ide = msg.sender_user_id_
msgm = msg.id_
local num = 100
for i=1,tonumber(num) do
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = {[0] = msgm}},function(arg,data) 
if data.messages_[0] ~= false then
if tonumber(my_ide) == (data.messages_[0].sender_user_id_) then
DeleteMessage(msg.chat_id_, {[0] = data.messages_[0].id_})
end;end;end, nil)
msgm = msgm - 1048576
end
Text = '⸙ ¦ العضو 𓄂 '..GetName..' \n⸙ ¦ قام بالتكرار المحدد تم كتمه '
SendText(msg.chat_id_,Text,0,'md')
return false  
end
end,nil)
end  
--  end functions Twix --
--     Source Twix     --
--       Spam Check       --
if not VipMem(msg) and msg.content_.ID ~= "MessageChatAddMembers" and DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Spam:User") then 
if msg.sender_user_id_ ~= Twix then
floods = DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Spam:User") or "nil"
Num_Msg_Max = DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5
Time_Spam = DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 5
local post_count = tonumber(DevHid:get(Twix.."Hid:Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_) or 0)
if post_count > tonumber(DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5) then 
local ch = msg.chat_id_
local type = DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Spam:User") 
NotSpam(msg,type)  
end
DevHid:setex(Twix.."Hid:Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_, tonumber(DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 3), post_count+1) 
local edit_id = data.text_ or "nil"  
Num_Msg_Max = 5
if DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam") then
Num_Msg_Max = DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam") 
end
if DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") then
Time_Spam = DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") 
end 
end
end 
--     Source Twix     --
----- START MSG CHECKS -----
if msg.sender_user_id_ and Ban(msg.sender_user_id_, msg.chat_id_) then
ChatKick(msg.chat_id_, msg.sender_user_id_)
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and BanAll(msg.sender_user_id_) then
ChatKick(msg.chat_id_, msg.sender_user_id_)
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and Muted(msg.sender_user_id_, msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.sender_user_id_ and MuteAll(msg.sender_user_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return false
end
if msg.content_.ID == "MessagePinMessage" then
if Constructor(msg) or tonumber(msg.sender_user_id_) == tonumber(Twix) then
DevHid:set(Twix..'Hid:PinnedMsg'..msg.chat_id_,msg.content_.message_id_)
else
local pin_id = DevHid:get(Twix..'Hid:PinnedMsg'..msg.chat_id_)
if pin_id and DevHid:get(Twix..'Hid:Lock:Pin'..msg.chat_id_) then
pinmsg(msg.chat_id_,pin_id,0)
end
end
end
if DevHid:get(Twix..'Hid:viewget'..msg.sender_user_id_) then
if not msg.forward_info_ then
DevHid:del(Twix..'Hid:viewget'..msg.sender_user_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عدد مشاهدات المنشور هي 𓄂 ('..msg.views_..')', 1, 'md')
DevHid:del(Twix..'Hid:viewget'..msg.sender_user_id_)
end
end
--     Source Twix     --
--         Photo          --
if msg.content_.ID == "MessagePhoto" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Photo'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
--        Markdown        --
elseif not msg.reply_markup_ and msg.via_bot_user_id_ ~= 0 then
if DevHid:get(Twix..'Hid:Lock:Markdown'..msg.chat_id_) then
if not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
--     Source Twix     --
--        Document        --
elseif msg.content_.ID == "MessageDocument" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Document'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
--         Inline         --
elseif msg.reply_markup_ and msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" and msg.via_bot_user_id_ ~= 0 then
if not VipMem(msg) then
if DevHid:get(Twix..'Hid:Lock:Inline'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
--     Source Twix     --
--        Sticker         --
elseif msg.content_.ID == "MessageSticker" then
if not VipMem(msg) then
if DevHid:get(Twix..'Hid:Lock:Stickers'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
elseif msg.content_.ID == "MessageChatJoinByLink" then
if DevHid:get(Twix..'Hid:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
function get_welcome(extra,result,success)
if DevHid:get(Twix..'Hid:Groups:Welcomes'..msg.chat_id_) then
Welcomes = DevHid:get(Twix..'Hid:Groups:Welcomes'..msg.chat_id_)
else
Welcomes = '• نورت حبي \n• firstname \n• @username'
end
local Welcomes = Welcomes:gsub('"',"") Welcomes = Welcomes:gsub("'","") Welcomes = Welcomes:gsub(",","") Welcomes = Welcomes:gsub("*","") Welcomes = Welcomes:gsub(";","") Welcomes = Welcomes:gsub("`","") Welcomes = Welcomes:gsub("{","") Welcomes = Welcomes:gsub("}","") 
local Welcomes = Welcomes:gsub('firstname',('['..result.first_name_..']' or ''))
local Welcomes = Welcomes:gsub('username',('[@'..result.username_..']' or '[@x_xxax]'))
Dev_Hid(msg.chat_id_, msg.id_, 1, Welcomes, 1, 'md')
end 
if DevHid:get(Twix.."Hid:Lock:Welcome"..msg.chat_id_) then
getUser(msg.sender_user_id_,get_welcome)
end
--     Source Twix     --
--      New User Add      --
elseif msg.content_.ID == "MessageChatAddMembers" then
if not DevHid:get(Twix..'Hid:Lock:BotWelcome') then 
tdcli_function ({ID = "GetUserProfilePhotos",user_id_ = Twix,offset_ = 0,limit_ = 1},function(extra,abbas,success) 
for i=0,#msg.content_.members_ do    
BotWelcome = msg.content_.members_[i].id_    
if BotWelcome and BotWelcome == tonumber(Twix) then 
if DevHid:sismember(Twix..'Hid:Groups',msg.chat_id_) then
BotText = "مفعله في السابق\n⸙ ¦ ارسل 𓄂 الاوامر واستمتع بالمميزيات"
else 
BotText = "معطله يجب رفعي مشرف\n⸙ ¦ بعد ذلك يرجى ارسال امر 𓄂 تفعيل\n⸙ ¦ سيتم رفع الادمنيه والمنشئ تلقائيا"
end 
local HidText = (DevHid:get(Twix.."Hid:Text:BotWelcome") or "⸙ ¦ مرحبا انا بوت اسمي "..NameBot.."\n⸙ ¦ حالة المجموعه 𓄂 "..BotText.."\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉")
local HidPhoto = (DevHid:get(Twix.."Hid:Photo:BotWelcome") or abbas.photos_[0].sizes_[1].photo_.persistent_id_)
if DevHid:get(Twix.."Hid:Photo:BotWelcome") or abbas.photos_[0] then
sendPhoto(msg.chat_id_,msg.id_,0,1,nil,HidPhoto,HidText)
else 
send(msg.chat_id_,msg.id_,HidText)
end 
end   
end
end,nil)
end
if DevHid:get(Twix..'Hid:Lock:TagServr'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and Ban(msg.content_.members_[0].id_, msg.chat_id_) then
ChatKick(msg.chat_id_, msg.content_.members_[0].id_)
DeleteMessage(msg.chat_id_, {[0] = msg.id_}) 
return false
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and BanAll(msg.content_.members_[0].id_) then
ChatKick(msg.chat_id_, msg.content_.members_[0].id_)
DeleteMessage(msg.chat_id_, {[0] = msg.id_}) 
return false
end
if DevHid:get(Twix.."Hid:Lock:Welcome"..msg.chat_id_) then
if DevHid:get(Twix..'Hid:Groups:Welcomes'..msg.chat_id_) then
Welcomes = DevHid:get(Twix..'Hid:Groups:Welcomes'..msg.chat_id_)
else
Welcomes = '• نورت حبي \n• firstname \n• @username'
end
local Welcomes = Welcomes:gsub('"',"") Welcomes = Welcomes:gsub("'","") Welcomes = Welcomes:gsub(",","") Welcomes = Welcomes:gsub("*","") Welcomes = Welcomes:gsub(";","") Welcomes = Welcomes:gsub("`","") Welcomes = Welcomes:gsub("{","") Welcomes = Welcomes:gsub("}","") 
local Welcomes = Welcomes:gsub('firstname',('['..msg.content_.members_[0].first_name_..']' or ''))
local Welcomes = Welcomes:gsub('username',('[@'..msg.content_.members_[0].username_..']' or '[@x_xxax]'))
Dev_Hid(msg.chat_id_, msg.id_, 1, Welcomes, 1, 'md')
end
--     Source Twix     --
--        Contact         --
elseif msg.content_.ID == "MessageContact" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Contact'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
--     Source Twix     --
--         Audio          --
elseif msg.content_.ID == "MessageAudio" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Music'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
--         Voice          --
elseif msg.content_.ID == "MessageVoice" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Voice'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
--        Location        --
elseif msg.content_.ID == "MessageLocation" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Location'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
return
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
--         Video          --
elseif msg.content_.ID == "MessageVideo" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Videos'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
--          Gif           --
elseif msg.content_.ID == "MessageAnimation" then
if not VipMem(msg) then
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if DevHid:get(Twix..'Hid:Lock:Gifs'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.caption_ then
Filters(msg, msg.content_.caption_)
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
if msg.content_.caption_:match("@") then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match(".[Ii][Rr]") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match(".[Oo][Rr][Gg]") or msg.content_.caption_:match(".[Ii][Nn][Ff][Oo]") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Xx][Yy][Zz]") or msg.content_.caption_:match(".[Tt][Kk]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.caption_:match("[A-Z]") or msg.content_.caption_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
--     Source Twix     --
--         Text           --
elseif msg.content_.ID == "MessageText" then
if not VipMem(msg) then
Filters(msg,text)
if msg.forward_info_ then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") then
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if DevHid:get(Twix..'Hid:Lock:Text'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if msg.content_.text_:match("@") then
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("#") then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Ii][Rr]") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match("[Ww][Ww][Ww].") or text:match(".[Tt][Kk]") or text:match(".[Xx][Yy][Zz]") or msg.content_.ID == "MessageEntityTextUrl" or msg.content_.ID == "MessageEntityUrl" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("[\216-\219][\128-\191]") then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_ then
local _nl, ctrl_chars = string.gsub(text, '%c', '')
local _nl, real_digits = string.gsub(text, '%d', '')
if not DevHid:get(Twix..'Hid:Spam:Text'..msg.chat_id_) then
sens = 400
else
sens = tonumber(DevHid:get(Twix..'Hid:Spam:Text'..msg.chat_id_))
end
if DevHid:get(Twix..'Hid:Lock:Spam'..msg.chat_id_) and string.len(msg.content_.text_) > (sens) or ctrl_chars > (sens) or real_digits > (sens) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
if msg.content_.text_:match("[A-Z]") or msg.content_.text_:match("[a-z]") then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
end
end
--     Source Twix     --
if DevHid:get(Twix.."Hid:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) then
if text == "الغاء" then
send(msg.chat_id_,msg.id_,"⸙ ¦ تم الغاء حفظ الرابط")       
DevHid:del(Twix.."Hid:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) 
return false
end
if msg.content_.text_:match("(https://telegram.me/joinchat/%S+)") or msg.content_.text_:match("(https://t.me/joinchat/%S+)") then
local Link = msg.content_.text_:match("(https://telegram.me/joinchat/%S+)") or msg.content_.text_:match("(https://t.me/joinchat/%S+)")
DevHid:set(Twix.."Hid:Groups:Links"..msg.chat_id_,Link)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ الرابط بنجاح', 1, 'md')
DevHid:del(Twix.."Hid:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_) 
return false 
end
end
--     Source Twix     --
local msg = data.message_
text = msg.content_.text_
if text and Constructor(msg) then 
if DevHid:get('HidTwixTEAM:'..Twix.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
DevHid:del('HidTwixTEAM:'..Twix..'id:user'..msg.chat_id_)  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء الامر', 1, 'md')
DevHid:del('HidTwixTEAM:'..Twix.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevHid:del('HidTwixTEAM:'..Twix.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = DevHid:get('HidTwixTEAM:'..Twix..'id:user'..msg.chat_id_)  
DevHid:incrby(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..iduserr,numadded)
Dev_Hid(msg.chat_id_, msg.id_,  1, "⸙ ¦ تم اضافة "..numadded..' رساله', 1, 'md')
DevHid:del('HidTwixTEAM:'..Twix..'id:user'..msg.chat_id_) 
end
end
if text and Constructor(msg) then 
if DevHid:get('HidTwixTEAM:'..Twix.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
DevHid:del('HidTwixTEAM:'..Twix..'ids:user'..msg.chat_id_)  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء الامر', 1, 'md')
DevHid:del('HidTwixTEAM:'..Twix.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevHid:del('HidTwixTEAM:'..Twix.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = DevHid:get('HidTwixTEAM:'..Twix..'ids:user'..msg.chat_id_)  
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..iduserr,numadded)  
Dev_Hid(msg.chat_id_, msg.id_,  1, "⸙ ¦ تم اضافة "..numadded..' نقطه', 1, 'md')
DevHid:del('HidTwixTEAM:'..Twix..'ids:user'..msg.chat_id_)  
end
end
--     Source Twix     --
if text and (text:match("طيز") or text:match("ديس") or text:match("انيج") or text:match("نيج") or text:match("ديوس") or text:match("عير") or text:match("كسختك") or text:match("كسمك") or text:match("كسربك") or text:match("بلاع") or text:match("ابو العيوره") or text:match("منيوج") or text:match("كحبه") or text:match("كحاب") or text:match("الكحبه") or text:match("كسك") or text:match("طيزك") or text:match("كس امك") or text:match("صرم") or text:match("كس اختك")) then
if not DevHid:get(Twix.."Hid:Lock:Fshar"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⸙ ¦ ممنوع الفشار في المجموعه")  
end end
if text and (text:match("ڬ") or text:match("ٺ") or text:match("چ") or text:match("ڇ") or text:match("ڿ") or text:match("ڀ") or text:match("ڎ") or text:match("ݫ") or text:match("ژ") or text:match("ڟ") or text:match("ݜ") or text:match("ڸ") or text:match("پ") or text:match("۴") or text:match("مک") or text:match("زدن") or text:match("دخترا") or text:match("دیوث") or text:match("کلیپشن") or text:match("خوششون") or text:match("میدا") or text:match("که") or text:match("بدانیم") or text:match("باید") or text:match("زناشویی") or text:match("آموزش") or text:match("راحتی") or text:match("خسته") or text:match("بیام") or text:match("بپوشم") or text:match("كرمه")) then
if DevHid:get(Twix.."Hid:Lock:Farsi"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⸙ ¦ ممنوع التكلم بالغه الفارسيه هنا")  
end end
if text and (text:match("ڬ") or text:match("ٺ") or text:match("چ") or text:match("ڇ") or text:match("ڿ") or text:match("ڀ") or text:match("ڎ") or text:match("ݫ") or text:match("ژ") or text:match("ڟ") or text:match("ݜ") or text:match("ڸ") or text:match("پ") or text:match("۴") or text:match("مک") or text:match("زدن") or text:match("دخترا") or text:match("دیوث") or text:match("کلیپشن") or text:match("خوششون") or text:match("میدا") or text:match("که") or text:match("بدانیم") or text:match("باید") or text:match("زناشویی") or text:match("آموزش") or text:match("راحتی") or text:match("خسته") or text:match("بیام") or text:match("بپوشم") or text:match("كرمه")) then
if DevHid:get(Twix.."Hid:Lock:FarsiBan"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ChatKick(msg.chat_id_, msg.sender_user_id_)
end end 
if text and (text:match("خره بالله") or text:match("خبربك") or text:match("كسدينربك") or text:match("خرب بالله") or text:match("خرب الله") or text:match("خره بربك") or text:match("الله الكواد") or text:match("خره بمحمد") or text:match("كسم الله") or text:match("كسم ربك") or text:match("كسربك") or text:match("كسختالله") or text:match("كسخت الله") or text:match("خره بدينك") or text:match("خرهبدينك") or text:match("كسالله") or text:match("خربالله")) then
if not DevHid:get(Twix.."Hid:Lock:Kfr"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⸙ ¦ ممنوع الكفر في المجموعه") 
end end
if text and (text:match("سني نكس") or text:match("شيعه") or text:match("الشيعه") or text:match("السنه") or text:match("طائفتكم") or text:match("شيعي") or text:match("انا سني") or text:match("مسيحي") or text:match("يهودي") or text:match("صابئي") or text:match("ملحد") or text:match("بالسنه") or text:match("شيعة")) then
if not DevHid:get(Twix.."Hid:Lock:Taf"..msg.chat_id_) and not VipMem(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
ReplyStatus(msg,msg.sender_user_id_,"WrongWay","⸙ ¦ ممنوع التكلم بالطائفيه هنا") 
end end
--     Source Twix     --
if SecondSudo(msg) then
if text == 'جلب نسخه الكروبات' and ChCheck(msg) or text == 'جلب نسخه احتياطيه' and ChCheck(msg) then
local List = DevHid:smembers(Twix..'Hid:Groups') 
local BotName = (DevHid:get(Twix.."Hid:NameBot") or 'تويكس')
local GetJson = '{"BotId": '..Twix..',"BotName": "'..BotName..'","GroupsList":{'  
for k,v in pairs(List) do 
LinkGroups = DevHid:get(Twix.."Hid:Groups:Links"..v)
Welcomes = DevHid:get(Twix..'Hid:Groups:Welcomes'..v) or ''
Welcomes = Welcomes:gsub('"',"") Welcomes = Welcomes:gsub("'","") Welcomes = Welcomes:gsub(",","") Welcomes = Welcomes:gsub("*","") Welcomes = Welcomes:gsub(";","") Welcomes = Welcomes:gsub("`","") Welcomes = Welcomes:gsub("{","") Welcomes = Welcomes:gsub("}","") 
HidConstructors = DevHid:smembers(Twix..'Hid:HidConstructor:'..v)
Constructors = DevHid:smembers(Twix..'Hid:BasicConstructor:'..v)
BasicConstructors = DevHid:smembers(Twix..'Hid:Constructor:'..v)
Managers = DevHid:smembers(Twix..'Hid:Managers:'..v)
Admis = DevHid:smembers(Twix..'Hid:Admins:'..v)
Vips = DevHid:smembers(Twix..'Hid:VipMem:'..v)
if k == 1 then
GetJson = GetJson..'"'..v..'":{'
else
GetJson = GetJson..',"'..v..'":{'
end
if #Vips ~= 0 then 
GetJson = GetJson..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Admis ~= 0 then
GetJson = GetJson..'"Admis":['
for k,v in pairs(Admis) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Managers ~= 0 then
GetJson = GetJson..'"Managers":['
for k,v in pairs(Managers) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #Constructors ~= 0 then
GetJson = GetJson..'"Constructors":['
for k,v in pairs(Constructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #BasicConstructors ~= 0 then
GetJson = GetJson..'"BasicConstructors":['
for k,v in pairs(BasicConstructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if #HidConstructors ~= 0 then
GetJson = GetJson..'"HidConstructors":['
for k,v in pairs(HidConstructors) do
if k == 1 then
GetJson =  GetJson..'"'..v..'"'
else
GetJson =  GetJson..',"'..v..'"'
end
end   
GetJson = GetJson..'],'
end
if LinkGroups then
GetJson = GetJson..'"LinkGroups":"'..LinkGroups..'",'
end
GetJson = GetJson..'"Welcomes":"'..Welcomes..'"}'
end
GetJson = GetJson..'}}'
local File = io.open('./'..Twix..'.json', "w")
File:write(GetJson)
File:close()
sendDocument(msg.chat_id_, msg.id_, 0, 1, nil, './'..Twix..'.json', '⸙ ¦ يحتوي الملف على 𓄂 '..#List..' مجموعه',dl_cb, nil)
io.popen('rm -rf ./'..Twix..'.json')
end
if text == 'رفع النسخه' and tonumber(msg.reply_to_message_id_) > 0 or text == 'رفع النسخه الاحتياطيه' and tonumber(msg.reply_to_message_id_) > 0 then   
function by_reply(extra, result, success)   
if result.content_.document_ then 
local ID_FILE = result.content_.document_.document_.persistent_id_ 
local File_Name = result.content_.document_.file_name_
AddFile(msg,msg.chat_id_,ID_FILE,File_Name)
end   
end
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, by_reply, nil)
end
end
--     Source Twix     --
if DevHid:get(Twix.."SET:GAME"..msg.chat_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 6 then
Dev_Hid( msg.chat_id_, msg.id_, 1,"⸙ ¦ يوجد فقط ( 6 ) اختيارات\n⸙ ¦ ارسل اختيارك مره اخرى", 1, "md")    
return false  end 
local GETNUM = DevHid:get(Twix.."GAMES"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
DevHid:del(Twix.."SET:GAME"..msg.chat_id_)   
Dev_Hid( msg.chat_id_, msg.id_, 1,'⸙ ¦ *المحيبس باليد رقم* 𓄂 '..NUM..'\n⸙ ¦ *مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*', 1, "md") 
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_,5)  
elseif tonumber(NUM) ~= tonumber(GETNUM) then
DevHid:del(Twix.."SET:GAME"..msg.chat_id_)   
Dev_Hid( msg.chat_id_, msg.id_, 1,'⸙ ¦ *المحيبس باليد رقم* 𓄂 '..GETNUM..'\n⸙ ¦ *للاسف لقد خسرت حاول مره اخرى للعثور على المحيبس*', 1, "md")
end
end
end
if DevHid:get(Twix..'DevHid4'..msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
send(msg.chat_id_, msg.id_, "⸙ ¦ تم الغاء الامر")
DevHid:del(Twix..'DevHid4'..msg.sender_user_id_)
return false  end 
DevHid:del(Twix..'DevHid4'..msg.sender_user_id_)
local username = string.match(text, "@[%a%d_]+") 
tdcli_function({ID = "SearchPublicChat",username_ = username},function(arg,data) 
if data and data.message_ and data.message_ == "USERNAME_NOT_OCCUPIED" then 
send(msg.chat_id_, msg.id_, '⸙ ¦ المعرف لا يوجد فيه قناة')
return false  end
if data and data.type_ and data.type_.ID and data.type_.ID == 'PrivateChatInfo' then
send(msg.chat_id_, msg.id_, '⸙ ¦ عذرا لا يمكنك وضع معرف حسابات في الاشتراك')
return false  end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.is_supergroup_ == true then
send(msg.chat_id_, msg.id_, '⸙ ¦ عذرا لا يمكنك وضع معرف مجموعه في الاشتراك')
return false  end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.is_supergroup_ == false then
if data and data.type_ and data.type_.channel_ and data.type_.channel_.ID and data.type_.channel_.status_.ID == 'ChatMemberStatusEditor' then
send(msg.chat_id_, msg.id_,'⸙ ¦ البوت ادمن في القناة \n⸙ ¦ تم تفعيل الاشتراك الاجباري \n⸙ ¦ ايدي القناة 𓄂 '..data.id_..'\n⸙ ¦ معرف القناة 𓄂 [@'..data.type_.channel_.username_..']')
DevHid:set(Twix..'DevHid2',data.id_)
DevHid:set(Twix..'DevHid3','@'..data.type_.channel_.username_)
else
send(msg.chat_id_, msg.id_,'⸙ ¦ عذرا البوت ليس ادمن في القناة')
end
return false  
end
end,nil)
end
--     Source Twix     --
if DevHid:get(Twix.."Hid:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
DevHid:del(Twix.."Hid:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء الامر', 1, 'md')
return false 
end 
DevHid:del(Twix.."Hid:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
local DevText = msg.content_.text_:match("(.*)")
DevHid:set(Twix.."DevText", DevText)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ كليشة المطور", 1, "md")
end
if DevHid:get(Twix..'Hid:NameBot'..msg.sender_user_id_) == 'msg' then
if text and text:match("^الغاء$") then 
DevHid:del(Twix..'Hid:NameBot'..msg.sender_user_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء الامر', 1, 'md')
return false 
end 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ اسم البوت ', 1, 'html')
DevHid:del(Twix..'Hid:NameBot'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:NameBot', text)
return false 
end
--     Source Twix     --
if text == "الرابط" then
if not DevHid:get(Twix.."Hid:Lock:GpLinks"..msg.chat_id_) then 
if DevHid:get(Twix.."Hid:Groups:Links"..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ 𝒈𝒓𝒐𝒖𝒑 𝒍𝒊𝒏𝒌 ↬ ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"..DevHid:get(Twix.."Hid:Groups:Links"..msg.chat_id_), 1, "html")
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لايوجد رابط ارسل 𓄂 ضع رابط او ارسل 𓄂 انشاء رابط للانشاء', 1, 'md')
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ جلب رابط المجموعه معطل', 1, 'md')
end
end
--     Source Twix     --
if ChatType == 'sp' or ChatType == 'gp'  then
if text == 'بوت' or text == 'بوتت' then 
NameBot = (DevHid:get(Twix..'Hid:NameBot') or 'تويكس')
local HidTwixTEAM = {"لتكول بوت اسمي "..NameBot.." 😒🔪","اسمي القميل "..NameBot.." 😚♥️","عندي اسم تره 😒💔","صيحولي "..NameBot.." كافي بوت 😒🔪","انت البوت لك 😒💔"} 
DevHid2 = math.random(#HidTwixTEAM) 
Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM[DevHid2] , 1, 'html') 
return false
end
if text == 'اسم البوت' or text == 'البوت شنو اسمه' or text == 'شسمه البوت' or text == 'البوت شسمه' then
NameBot = (DevHid:get(Twix..'Hid:NameBot') or 'تويكس') 
local HidTwixTEAM = {"اسمي القميل "..NameBot.." 😚♥️","هلاا يروحيي وياكك "..NameBot.." 😻♥️"} 
DevHid2 = math.random(#HidTwixTEAM) 
Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM[DevHid2] , 1, 'html') 
return false
end
if text and text == (DevHid:get(Twix..'Hid:NameBot') or 'تويكس') then 
NameBot = (DevHid:get(Twix..'Hid:NameBot') or 'تويكس')
local namebot = {'😸♥️ هلا كلبي وياك '..NameBot..' تفضل','ترةه مصختهاا احجيي شرايد 😕😒💔','اطلقق واحدد يصيح '..NameBot..' 😻♥️','خبصتت امنةة شتريدد عااد 🤧😒💔'} 
name = math.random(#namebot) 
Dev_Hid(msg.chat_id_, msg.id_, 1, namebot[name] , 1, 'html') 
return false 
end
if text =='نقاطي' and ChCheck(msg) then 
if tonumber((DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)) == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لم تربح اي نقطه\n⸙ ¦ ارسل 𓄂 الالعاب للعب', 1, 'md')
else 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ عدد النقاط التي ربحتها 𓄂 '..(DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_)), 1, 'md')
end
end
if text ==  'حذف رسائلي' and ChCheck(msg) or text ==  'مسح رسائلي' and ChCheck(msg) then DevHid:del(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_) Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حذف جميع رسائلك', 1, 'md') end
if text ==  'حذف نقاطي' and ChCheck(msg) or text ==  'مسح نقاطي' and ChCheck(msg) then DevHid:del(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_) Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حذف جميع نقاطك', 1, 'md') end
--     Source Twix     --
if text == 'سمايلات' and ChCheck(msg) or text == 'السمايلات' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'🍏','🍎','🍐','🍊','🍋','🍌','🍉','🍇','🍓','🍈','🍒','🍑','🍍','🥥','🥝','🍅','🍆','🥑','🥦','🥒','🌶','🌽','🥕','🥔','🍠','🥐','🍞','🥖','🥨','🧀','🥚','🍳','🥞','🥓','🥩','🍗','🍖','🌭','🍔','🍟','🍕','🥪','🥙','🍼','☕️','🍵','🥤','🍶','🍺','🍻','🏀','⚽️','🏈','⚾️','🎾','🏐','🏉','🎱','🏓','🏸','🥅','🎰','🎮','🎳','🎯','🏆','🎻','🎸','🎺','🥁','🎹','🎼','🎧','🎤','🎬','🎨','🎭','🎪','🛎','📤','🎗','🏵','🎖','🏆','🥌','🛷','🚕','🚗','🚙','🚌','🚎','🏎','🚓','🚑','🚚','🚛','🚜','🇮🇶','⚔️','🛡','🔮','🌡','💣','⏱','🛢','📓','📗','📂','📅','📪','📫','📬','📭','⏰','📺','🎚','☎️','📡'}
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'🍞','🍞')
name = string.gsub(name,'🥖','🥖')
name = string.gsub(name,'🥨','🥨')
name = string.gsub(name,'🧀','🧀')
name = string.gsub(name,'🥚','🥚')
name = string.gsub(name,'🍳','🍳')
name = string.gsub(name,'🥞','🥞')
name = string.gsub(name,'🥓','🥓')
name = string.gsub(name,'🥩','🥩')
name = string.gsub(name,'🍗','🍗')
name = string.gsub(name,'🍖','🍖')
name = string.gsub(name,'🌭','🌭')
name = string.gsub(name,'🍔','🍔')
name = string.gsub(name,'🍟','🍟')
name = string.gsub(name,'🍕','🍕')
name = string.gsub(name,'🥪','🥪')
name = string.gsub(name,'🥙','🥙')
name = string.gsub(name,'🍼','🍼')
name = string.gsub(name,'☕️','☕️')
name = string.gsub(name,'🍵','🍵')
name = string.gsub(name,'🥤','🥤')
name = string.gsub(name,'🍶','🍶')
name = string.gsub(name,'🍺','🍺')
name = string.gsub(name,'🍏','🍏')
name = string.gsub(name,'🍎','🍎')
name = string.gsub(name,'🍐','🍐')
name = string.gsub(name,'🍊','🍊')
name = string.gsub(name,'🍋','🍋')
name = string.gsub(name,'🍌','🍌')
name = string.gsub(name,'🍉','🍉')
name = string.gsub(name,'🍇','🍇')
name = string.gsub(name,'🍓','🍓')
name = string.gsub(name,'🍈','🍈')
name = string.gsub(name,'🍒','🍒')
name = string.gsub(name,'🍑','🍑')
name = string.gsub(name,'🍍','🍍')
name = string.gsub(name,'🥥','🥥')
name = string.gsub(name,'🥝','🥝')
name = string.gsub(name,'🍅','🍅')
name = string.gsub(name,'🍆','🍆')
name = string.gsub(name,'🥑','🥑')
name = string.gsub(name,'🥦','🥦')
name = string.gsub(name,'🥒','🥒')
name = string.gsub(name,'🌶','🌶')
name = string.gsub(name,'🌽','🌽')
name = string.gsub(name,'🥕','🥕')
name = string.gsub(name,'🥔','🥔')
name = string.gsub(name,'🍠','🍠')
name = string.gsub(name,'🥐','🥐')
name = string.gsub(name,'🍻','🍻')
name = string.gsub(name,'🏀','🏀')
name = string.gsub(name,'⚽️','⚽️')
name = string.gsub(name,'🏈','🏈')
name = string.gsub(name,'⚾️','⚾️')
name = string.gsub(name,'🎾','🎾')
name = string.gsub(name,'🏐','🏐')
name = string.gsub(name,'🏉','🏉')
name = string.gsub(name,'🎱','🎱')
name = string.gsub(name,'🏓','🏓')
name = string.gsub(name,'🏸','🏸')
name = string.gsub(name,'🥅','🥅')
name = string.gsub(name,'🎰','🎰')
name = string.gsub(name,'🎮','🎮')
name = string.gsub(name,'🎳','🎳')
name = string.gsub(name,'🎯','🎯')
name = string.gsub(name,'🏆','🏆')
name = string.gsub(name,'🎻','🎻')
name = string.gsub(name,'🎸','🎸')
name = string.gsub(name,'🎺','🎺')
name = string.gsub(name,'🥁','🥁')
name = string.gsub(name,'🎹','🎹')
name = string.gsub(name,'🎼','🎼')
name = string.gsub(name,'🎧','🎧')
name = string.gsub(name,'🎤','🎤')
name = string.gsub(name,'🎬','🎬')
name = string.gsub(name,'🎨','🎨')
name = string.gsub(name,'🎭','🎭')
name = string.gsub(name,'🎪','🎪')
name = string.gsub(name,'🛎','🛎')
name = string.gsub(name,'📤','📤')
name = string.gsub(name,'🎗','🎗')
name = string.gsub(name,'🏵','🏵')
name = string.gsub(name,'🎖','🎖')
name = string.gsub(name,'🏆','🏆')
name = string.gsub(name,'🥌','🥌')
name = string.gsub(name,'🛷','🛷')
name = string.gsub(name,'🚕','🚕')
name = string.gsub(name,'🚗','🚗')
name = string.gsub(name,'🚙','🚙')
name = string.gsub(name,'🚌','🚌')
name = string.gsub(name,'🚎','🚎')
name = string.gsub(name,'🏎','🏎')
name = string.gsub(name,'🚓','🚓')
name = string.gsub(name,'🚑','🚑')
name = string.gsub(name,'🚚','🚚')
name = string.gsub(name,'🚛','🚛')
name = string.gsub(name,'🚜','🚜')
name = string.gsub(name,'🇮🇶','🇮🇶')
name = string.gsub(name,'⚔️','⚔️')
name = string.gsub(name,'🛡','🛡')
name = string.gsub(name,'🔮','🔮')
name = string.gsub(name,'🌡','🌡')
name = string.gsub(name,'💣','💣')
name = string.gsub(name,'⏱','⏱')
name = string.gsub(name,'🛢','🛢')
name = string.gsub(name,'📒','📒')
name = string.gsub(name,'📗','📗')
name = string.gsub(name,'📅','📆')
name = string.gsub(name,'📪','📪')
name = string.gsub(name,'📫','📫')
name = string.gsub(name,'📬','📬')
name = string.gsub(name,'📭','📭')
name = string.gsub(name,'⏰','⏰')
name = string.gsub(name,'📺','📺')
name = string.gsub(name,'🎚','🎚')
name = string.gsub(name,'☎️','☎️')
HidTwixTEAM = '⸙ ¦ اول واحد يدز هذا السمايل يربح 𓄂 '..name
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum'..msg.chat_id_) and not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 سمايلات للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end
if text == 'ترتيب' and ChCheck(msg) or text == 'الترتيب' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'سحور','سياره','استقبال','قنفه','ايفون','بزونه','مطبخ','كرستيانو','دجاجه','مدرسه','الوان','غرفه','ثلاجه','كهوه','سفينه','العراق','محطه','طياره','رادار','منزل','مستشفى','كهرباء','تفاحه','اخطبوط','سلمون','فرنسا','برتقاله','تفاح','مطرقه','بتيته','لهانه','شباك','باص','سمكه','ذباب','تلفاز','حاسوب','انترنيت','ساحه','جسر'};
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'سحور','س ر و ح')
name = string.gsub(name,'سياره','ه ر س ي ا')
name = string.gsub(name,'استقبال','ل ب ا ت ق س ا')
name = string.gsub(name,'قنفه','ه ق ن ف')
name = string.gsub(name,'ايفون','و ن ف ا')
name = string.gsub(name,'بزونه','ز و ه ن')
name = string.gsub(name,'مطبخ','خ ب ط م')
name = string.gsub(name,'كرستيانو','س ت ا ن و ك ر ي')
name = string.gsub(name,'دجاجه','ج ج ا د ه')
name = string.gsub(name,'مدرسه','ه م د ر س')
name = string.gsub(name,'الوان','ن ا و ا ل')
name = string.gsub(name,'غرفه','غ ه ر ف')
name = string.gsub(name,'ثلاجه','ج ه ت ل ا')
name = string.gsub(name,'كهوه','ه ك ه و')
name = string.gsub(name,'سفينه','ه ن ف ي س')
name = string.gsub(name,'العراق','ق ع ا ل ر ا')
name = string.gsub(name,'محطه','ه ط م ح')
name = string.gsub(name,'طياره','ر ا ط ي ه')
name = string.gsub(name,'رادار','ر ا ر ا د')
name = string.gsub(name,'منزل','ن ز م ل')
name = string.gsub(name,'مستشفى','ى ش س ف ت م')
name = string.gsub(name,'كهرباء','ر ب ك ه ا ء')
name = string.gsub(name,'تفاحه','ح ه ا ت ف')
name = string.gsub(name,'اخطبوط','ط ب و ا خ ط')
name = string.gsub(name,'سلمون','ن م و ل س')
name = string.gsub(name,'فرنسا','ن ف ر س ا')
name = string.gsub(name,'برتقاله','ر ت ق ب ا ه ل')
name = string.gsub(name,'تفاح','ح ف ا ت')
name = string.gsub(name,'مطرقه','ه ط م ر ق')
name = string.gsub(name,'بتيته','ب ت ت ي ه')
name = string.gsub(name,'لهانه','ه ن ل ه ل')
name = string.gsub(name,'شباك','ب ش ا ك')
name = string.gsub(name,'باص','ص ا ب')
name = string.gsub(name,'سمكه','ك س م ه')
name = string.gsub(name,'ذباب','ب ا ب ذ')
name = string.gsub(name,'تلفاز','ت ف ل ز ا')
name = string.gsub(name,'حاسوب','س ا ح و ب')
name = string.gsub(name,'انترنيت','ا ت ن ر ن ي ت')
name = string.gsub(name,'ساحه','ح ا ه س')
name = string.gsub(name,'جسر','ر ج س')
HidTwixTEAM = '⸙ ¦ اول واحد يرتبها يربح 𓄂 '..name
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum'..msg.chat_id_) and not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 ترتيب للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end
if text == 'محيبس' and ChCheck(msg) or text == 'بات' and ChCheck(msg) or text == 'المحيبس' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
Num = math.random(1,6)
DevHid:set(Twix.."GAMES"..msg.chat_id_,Num) 
TEST = [[
➀     ➁     ➂     ➃     ➄     ➅
↓     ↓     ↓     ↓     ↓     ↓
👊 ‹› 👊🏻 ‹› 👊🏼 ‹› 👊🏽 ‹› 👊🏾 ‹› 👊🏿

⸙ ¦ اختر رقم لاستخراج المحيبس
⸙ ¦ الفائز يحصل على (5) نقاط
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, TEST, 1, "md") 
DevHid:setex(Twix.."SET:GAME"..msg.chat_id_, 100, true)  
return false  
end end
if text == 'حزوره' and ChCheck(msg) or text == 'الحزوره' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'الجرس','عقرب الساعه','السمك','المطر','5','الكتاب','البسمار','7','الكعبه','بيت الشعر','لهانه','انا','امي','الابره','الساعه','22','غلط','كم الساعه','البيتنجان','البيض','المرايه','الضوء','الهواء','الضل','العمر','القلم','المشط','الحفره','البحر','الثلج','الاسفنج','الصوت','بلم'};
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'الجرس','شيئ اذا لمسته صرخ ما هوه ؟')
name = string.gsub(name,'عقرب الساعه','اخوان لا يستطيعان تمضيه اكثر من دقيقه معا فما هما ؟')
name = string.gsub(name,'السمك','ما هو الحيوان الذي لم يصعد الى سفينة نوح عليه السلام ؟')
name = string.gsub(name,'المطر','شيئ يسقط على رأسك من الاعلى ولا يجرحك فما هو ؟')
name = string.gsub(name,'5','ما العدد الذي اذا ضربته بنفسه واضفت عليه 5 يصبح ثلاثين ')
name = string.gsub(name,'الكتاب','ما الشيئ الذي له اوراق وليس له جذور ؟')
name = string.gsub(name,'البسمار','ما هو الشيئ الذي لا يمشي الا بالضرب ؟')
name = string.gsub(name,'7','عائله مؤلفه من 6 بنات واخ لكل منهن .فكم عدد افراد العائله ')
name = string.gsub(name,'الكعبه','ما هو الشيئ الموجود وسط مكة ؟')
name = string.gsub(name,'بيت الشعر','ما هو البيت الذي ليس فيه ابواب ولا نوافذ ؟ ')
name = string.gsub(name,'لهانه','وحده حلوه ومغروره تلبس مية تنوره .من هيه ؟ ')
name = string.gsub(name,'انا','ابن امك وابن ابيك وليس باختك ولا باخيك فمن يكون ؟')
name = string.gsub(name,'امي','اخت خالك وليست خالتك من تكون ؟ ')
name = string.gsub(name,'الابره','ما هو الشيئ الذي كلما خطا خطوه فقد شيئا من ذيله ؟ ')
name = string.gsub(name,'الساعه','ما هو الشيئ الذي يقول الصدق ولكنه اذا جاع كذب ؟')
name = string.gsub(name,'22','كم مره ينطبق عقربا الساعه على بعضهما في اليوم الواحد ')
name = string.gsub(name,'غلط','ما هي الكلمه الوحيده التي تلفض غلط دائما ؟ ')
name = string.gsub(name,'كم الساعه','ما هو السؤال الذي تختلف اجابته دائما ؟')
name = string.gsub(name,'البيتنجان','جسم اسود وقلب ابيض وراس اخظر فما هو ؟')
name = string.gsub(name,'البيض','ماهو الشيئ الذي اسمه على لونه ؟')
name = string.gsub(name,'المرايه','ارى كل شيئ من دون عيون من اكون ؟ ')
name = string.gsub(name,'الضوء','ما هو الشيئ الذي يخترق الزجاج ولا يكسره ؟')
name = string.gsub(name,'الهواء','ما هو الشيئ الذي يسير امامك ولا تراه ؟')
name = string.gsub(name,'الضل','ما هو الشيئ الذي يلاحقك اينما تذهب ؟ ')
name = string.gsub(name,'العمر','ما هو الشيء الذي كلما طال قصر ؟ ')
name = string.gsub(name,'القلم','ما هو الشيئ الذي يكتب ولا يقرأ ؟')
name = string.gsub(name,'المشط','له أسنان ولا يعض ما هو ؟ ')
name = string.gsub(name,'الحفره','ما هو الشيئ اذا أخذنا منه ازداد وكبر ؟')
name = string.gsub(name,'البحر','ما هو الشيئ الذي يرفع اثقال ولا يقدر يرفع مسمار ؟')
name = string.gsub(name,'الثلج','انا ابن الماء فان تركوني في الماء مت فمن انا ؟')
name = string.gsub(name,'الاسفنج','كلي ثقوب ومع ذالك احفض الماء فمن اكون ؟')
name = string.gsub(name,'الصوت','اسير بلا رجلين ولا ادخل الا بالاذنين فمن انا ؟')
name = string.gsub(name,'بلم','حامل ومحمول نصف ناشف ونصف مبلول فمن اكون ؟ ')
HidTwixTEAM = '⸙ ¦ اول واحد يحلها يربح 𓄂 '..name
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum'..msg.chat_id_) and not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 حزوره للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end 
if text == 'المعاني' and ChCheck(msg) or text == 'معاني' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'قرد','دجاجه','بطريق','ضفدع','بومه','نحله','ديك','جمل','بقره','دولفين','تمساح','قرش','نمر','اخطبوط','سمكه','خفاش','اسد','فأر','ذئب','فراشه','عقرب','زرافه','قنفذ','تفاحه','باذنجان'}
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum2'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'قرد','🐒')
name = string.gsub(name,'دجاجه','🐔')
name = string.gsub(name,'بطريق','🐧')
name = string.gsub(name,'ضفدع','🐸')
name = string.gsub(name,'بومه','🦉')
name = string.gsub(name,'نحله','🐝')
name = string.gsub(name,'ديك','🐓')
name = string.gsub(name,'جمل','🐫')
name = string.gsub(name,'بقره','🐄')
name = string.gsub(name,'دولفين','🐬')
name = string.gsub(name,'تمساح','🐊')
name = string.gsub(name,'قرش','🦈')
name = string.gsub(name,'نمر','🐅')
name = string.gsub(name,'اخطبوط','🐙')
name = string.gsub(name,'سمكه','🐟')
name = string.gsub(name,'خفاش','🦇')
name = string.gsub(name,'اسد','🦁')
name = string.gsub(name,'فأر','🐭')
name = string.gsub(name,'ذئب','🐺')
name = string.gsub(name,'فراشه','🦋')
name = string.gsub(name,'عقرب','🦂')
name = string.gsub(name,'زرافه','🦒')
name = string.gsub(name,'قنفذ','🦔')
name = string.gsub(name,'تفاحه','🍎')
name = string.gsub(name,'باذنجان','🍆')
HidTwixTEAM = '⸙ ¦ ما معنى هذا السمايل :؟ 𓄂 '..name
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum2'..msg.chat_id_) and not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 المعاني للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end 
if text == 'العكس' and ChCheck(msg) or text == 'عكس' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'باي','فهمت','موزين','اسمعك','احبك','موحلو','نضيف','حاره','ناصي','جوه','سريع','ونسه','طويل','سمين','ضعيف','شريف','شجاع','رحت','عدل','نشيط','شبعان','موعطشان','خوش ولد','اني','هادئ'}
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum3'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'باي','هلو')
name = string.gsub(name,'فهمت','مافهمت')
name = string.gsub(name,'موزين','زين')
name = string.gsub(name,'اسمعك','ماسمعك')
name = string.gsub(name,'احبك','ماحبك')
name = string.gsub(name,'محلو','حلو')
name = string.gsub(name,'نضيف','وصخ')
name = string.gsub(name,'حاره','بارده')
name = string.gsub(name,'ناصي','عالي')
name = string.gsub(name,'جوه','فوك')
name = string.gsub(name,'سريع','بطيء')
name = string.gsub(name,'ونسه','ضوجه')
name = string.gsub(name,'طويل','قزم')
name = string.gsub(name,'سمين','ضعيف')
name = string.gsub(name,'ضعيف','قوي')
name = string.gsub(name,'شريف','كواد')
name = string.gsub(name,'شجاع','جبان')
name = string.gsub(name,'رحت','اجيت')
name = string.gsub(name,'حي','ميت')
name = string.gsub(name,'نشيط','كسول')
name = string.gsub(name,'شبعان','جوعان')
name = string.gsub(name,'موعطشان','عطشان')
name = string.gsub(name,'خوش ولد','موخوش ولد')
name = string.gsub(name,'اني','مطي')
name = string.gsub(name,'هادئ','عصبي')
HidTwixTEAM = '⸙ ¦ ما هو عكس كلمة 𓄂 '..name
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum3'..msg.chat_id_) and not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 العكس للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end 
if text == 'المختلف' and ChCheck(msg) or text == 'مختلف' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'😸','☠','🐼','🐇','🌑','🌚','⭐️','📥','⛈','🌥','⛄️','👨‍🔬','👨‍💻','👨‍🔧','👩‍🍳','🧚‍♀','🧚‍♂️','🧝‍♂','🙍‍♂','🧖‍♂','👬','👨‍👨‍👧','🕓','🕤','⌛️','📅','👩‍⚖️','👨‍🎨'};
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum4'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'😸','😹😹😹😸😹😹😹😹')
name = string.gsub(name,'☠️','💀💀💀☠️💀💀💀💀')
name = string.gsub(name,'🐼','👻👻👻👻👻👻👻🐼')
name = string.gsub(name,'🐇','🕊🕊🕊🕊🕊🐇🕊🕊')
name = string.gsub(name,'🌑','🌚🌚🌚🌚🌚🌑🌚🌚')
name = string.gsub(name,'🌚','🌑🌑🌑🌑🌑🌚🌑🌑')
name = string.gsub(name,'⭐️','🌟🌟🌟🌟🌟🌟⭐️🌟')
name = string.gsub(name,'📥','💫💫💫📥💫💫💫💫')
name = string.gsub(name,'⛈','🌨🌨🌨⛈🌨🌨🌨🌨')
name = string.gsub(name,'🌥','⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️')
name = string.gsub(name,'⛄️','☃️☃️☃️☃️⛄️☃️☃️☃️☃️')
name = string.gsub(name,'👨‍🔬','👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬')
name = string.gsub(name,'👨‍💻','👩‍💻👩‍💻👨‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻')
name = string.gsub(name,'👨‍🔧','👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧')
name = string.gsub(name,'👩‍🍳','👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳')
name = string.gsub(name,'🧚‍♀️','🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♂️🧚‍♀️🧚‍♂️🧚‍♂️')
name = string.gsub(name,'🧚‍♂️','🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♀️🧚‍♂️🧚‍♀️🧚‍♀️')
name = string.gsub(name,'🧝‍♂️','🧝‍♀️🧝‍♀️🧝‍♀️🧝‍♂️🧝‍♀️🧝‍♀️🧝‍♀️🧝‍♀️')
name = string.gsub(name,'🙍‍♂️','🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️')
name = string.gsub(name,'🧖‍♂️','🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️')
name = string.gsub(name,'👬','👭👭👭👭👬👭👭👭')
name = string.gsub(name,'👨‍👨‍👧','👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦')
name = string.gsub(name,'🕓','🕒🕒🕒🕒🕓🕒🕒🕒')
name = string.gsub(name,'🕤','🕥🕥🕥🕥🕥🕤🕥🕥')
name = string.gsub(name,'⌛️','⏳⏳⏳⏳⏳⌛️⏳⏳')
name = string.gsub(name,'📅','📆📆📆📆📆📅📆📆')
name = string.gsub(name,'👩‍⚖️','👨‍⚖️👨‍⚖️👨‍⚖️👨‍⚖️👨‍⚖️👩‍⚖️👨‍⚖️👨‍⚖️')
name = string.gsub(name,'👨‍🎨','👩‍🎨👩‍🎨👨‍🎨👩‍🎨👩‍🎨👩‍🎨👩‍🎨👩‍🎨')
HidTwixTEAM = '⸙ ¦ اول واحد يطلع المختلف يربح\n{'..name..'} '
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum4'..msg.chat_id_) and not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 المختلف للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end  
if text == 'امثله' and ChCheck(msg) or text == 'الامثله' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {
'جوز','ضراطه','الحبل','الحافي','شقره','بيدك','سلايه','النخله','الخيل','حداد','المبلل','يركص','قرد','العنب','العمه','الخبز','بالحصاد','شهر','شكه','يكحله',
};
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum5'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'جوز','ينطي ___ للماعنده سنون')
name = string.gsub(name,'ضراطه','الي يسوق المطي يتحمل ___ ')
name = string.gsub(name,'بيدك','اكل ___ محد يفيدك')
name = string.gsub(name,'الحافي','تجدي من ___ نعال')
name = string.gsub(name,'شقره','مع الخيل يا ___ ')
name = string.gsub(name,'النخله','الطول طول ___ والعقل عقل الصخلة')
name = string.gsub(name,'سلايه','بالوجه امراية وبالظهر ___ ')
name = string.gsub(name,'الخيل','من قلة ___ شدو على الچلاب سروج')
name = string.gsub(name,'حداد','موكل من صخم وجهه كال آني ___ ')
name = string.gsub(name,'المبلل',' ___ ما يخاف من المطر')
name = string.gsub(name,'الحبل','اللي تلدغة الحية يخاف من جرة ___ ')
name = string.gsub(name,'يركص','المايعرف ___ يكول الكاع عوجه')
name = string.gsub(name,'العنب','المايلوح ___ يكول حامض')
name = string.gsub(name,'العمه','___ إذا حبت الچنة ابليس يدخل الجنة')
name = string.gsub(name,'الخبز','انطي ___ للخباز حتى لو ياكل نصه')
name = string.gsub(name,'بالحصاد','اسمة ___ ومنجله مكسور')
name = string.gsub(name,'شهر','امشي ___ ولا تعبر نهر')
name = string.gsub(name,'شكه','يامن تعب يامن ___ يا من على الحاضر لكة')
name = string.gsub(name,'القرد',' ___ بعين امه غزال')
name = string.gsub(name,'يكحله','اجه ___ عماها')
HidTwixTEAM = '⸙ ¦ اكمل المثال التالي 𓄂 ['..name..']'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum5'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevHid:del(Twix..'Hid:GameNum5'..msg.chat_id_)
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 امثله للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end  
if text == 'رياضيات' and ChCheck(msg) or text == 'الرياضيات' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'9','46','2','9','5','4','25','10','17','15','39','5','16',};
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum6'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'9','7 + 2 = ?')
name = string.gsub(name,'46','41 + 5 = ?')
name = string.gsub(name,'2','5 - 3 = ?')
name = string.gsub(name,'9','5 + 2 + 2 = ?')
name = string.gsub(name,'5','8 - 3 = ?')
name = string.gsub(name,'4','40 ÷ 10 = ?')
name = string.gsub(name,'25','30 - 5 = ?')
name = string.gsub(name,'10','100 ÷ 10 = ?')
name = string.gsub(name,'17','10 + 5 + 2 = ?')
name = string.gsub(name,'15','25 - 10 = ?')
name = string.gsub(name,'39','44 - 5 = ?')
name = string.gsub(name,'5','12 + 1 - 8 = ?')
name = string.gsub(name,'16','16 + 16 - 16 = ?')
HidTwixTEAM = '⸙ ¦ اكمل المعادله التاليه 𓄂 ⤈\n{'..name..'} '
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum6'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevHid:del(Twix..'Hid:GameNum6'..msg.chat_id_)
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 رياضيات للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end  
if text == 'الانكليزي' and ChCheck(msg) or text == 'الانجليزيه' and ChCheck(msg) or text == 'انكليزيه' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'معلومات','قنوات','مجموعات','كتاب','تفاحه','سدني','نقود','اعلم','ذئب','تمساح','ذكي','شاطئ','غبي',};
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum7'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'ذئب','Wolf')
name = string.gsub(name,'معلومات','Information')
name = string.gsub(name,'قنوات','Channels')
name = string.gsub(name,'مجموعات','Groups')
name = string.gsub(name,'كتاب','Book')
name = string.gsub(name,'تفاحه','Apple')
name = string.gsub(name,'نقود','money')
name = string.gsub(name,'اعلم','I know')
name = string.gsub(name,'تمساح','crocodile')
name = string.gsub(name,'شاطئ','Beach')
name = string.gsub(name,'غبي','Stupid')
name = string.gsub(name,'صداقه','Friendchip')
HidTwixTEAM = '⸙ ¦ ما معنى كلمة 𓄂 '..name
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum7'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevHid:del(Twix..'Hid:GameNum7'..msg.chat_id_)
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 انكليزيه للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end  
--     Source Twix     --
if text == 'اسئله' and ChCheck(msg) or text == 'اختيارات' and ChCheck(msg) or text == 'الاسئله' and ChCheck(msg) or text == 'اساله' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid2 = {'النيل','14','الفم','11','30','بوتين','ستيف جوبر','باريس','10','النمل','حرف الواو','الشعر','سحاب','الاسم','ذهب','حرف الام','العزائم','انسات','المنجنيق','اسيا','6','الاسد','مهر','الدولفين','اوروبا','الزئبق','لندن','الانسان','طوكيو','خديجه',}
name = DevHid2[math.random(#DevHid2)]
DevHid:set(Twix..'Hid:GameNum8'..msg.chat_id_,name)
DevHid:del(Twix..'Hid:Games:Ids'..msg.chat_id_)
name = string.gsub(name,'النيل','⸙ ¦ ماهو اطول نهر في العالم ؟\n1- النيل\n2- الفرات\n3- نهر الكونغو')
name = string.gsub(name,'14','⸙ ¦ ماعدد عظام الوجه ؟\n1- 15\n2- 13\n3- 14')
name = string.gsub(name,'الفم','⸙ ¦ كراسي بيضاء وجدران ورديه اذا اغلقته اصبح ظلام  فمن اكون ؟\n1- الفم\n2- الاذن\n3- الثلاجه')
name = string.gsub(name,'11','⸙ ¦ كم جزء يحتوي مسلسل وادي الذئاب ؟\n1- 7\n2- 15\n3- 11')
name = string.gsub(name,'30','⸙ ¦ كم جزء يحتوي القران الكريم ؟\n1- 60\n2- 70\n3- 30')
name = string.gsub(name,'بوتين','⸙ ¦ من هوه اغنى رئيس في العالم ؟\n1- ترامب\n2- اوباما\n3- بوتين')
name = string.gsub(name,'ستيف جوبر','⸙ ¦ من هوه مؤسس شركه ابل العالميه  ؟\n1- لاري بايج\n2- بيل جيتس\n3- ستيف جوبر')
name = string.gsub(name,'باريس','ماهي عاصمه فرنسا ؟\n1- باريس\n2- لوين\n3- موسكو')
name = string.gsub(name,'10','⸙ ¦ ماعدد دول العربيه التي توجد في افريقيا ؟\n1- 10\n2- 17\n3- 9')
name = string.gsub(name,'النمل','⸙ ¦ ماهو الحيوان الذي يحمل 50 فوق وزنه ؟\n1- الفيل\n2- النمل\n3- الثور')
name = string.gsub(name,'حرف الواو','⸙ ¦ ماذا يوجد بيني وبينك ؟\n1- الضل\n2- الاخلاق\n3- حرف الواو')
name = string.gsub(name,'الشعر','⸙ ¦ ماهو الشيء النبات ينبت للانسان بلا بذر ؟\n1- الاضافر\n2- الاسنان\n3- الشعر')
name = string.gsub(name,'سحاب','⸙ ¦ ما هو الشّيء الذي يستطيع المشي بدون أرجل والبكاء بدون أعين ؟\n1- سحاب\n2- بئر\n3- نهر')
name = string.gsub(name,'الاسم','⸙ ¦ ما الشيء الذي نمتلكه , لكنّ غيرنا يستعمله أكثر منّا ؟\n1- العمر\n2- ساعه\n3- الاسم')
name = string.gsub(name,'ذهب','⸙ ¦ اصفر اللون سارق عقول اهل الكون وحارمهم لذيذ النوم ؟\n1- نحاس\n2- الماس\n3- ذهب')
name = string.gsub(name,'حرف الام','⸙ ¦ في الليل ثلاثة لكنه في النهار واحده فما هو ؟\n1- حرف الباء\n2- حرف الام\n3- حرف الراء')
name = string.gsub(name,'العزائم','⸙ ¦ على قدر اصل العزم تأتي ؟\n1- العزائم\n2- المكارم\n3- المبائب')
name = string.gsub(name,'انسات','⸙ ¦ ماهي جمع كلمه انسه ؟\n1- سيدات\n2- انسات\n3- قوانص')
name = string.gsub(name,'المنجنيق','⸙ ¦ اله اتسعلمت قديما في الحروب ؟\n1- الصاروخ\n2- المسدس\n3- المنجنيق')
name = string.gsub(name,'اسيا','⸙ ¦ تقع لبنان في قاره ؟\n1- افريقيا\n2- اسيا\n3- امركيا الشماليه')
name = string.gsub(name,'6','⸙ ¦ كم صفرا للمليون ؟\n1- 4\n2- 3\n3- 6')
name = string.gsub(name,'الاسد','⸙ ¦ ماهو الحيوان الذي يلقب بملك الغابه ؟\n1- الفيل\n2- الاسد\n3- النمر')
name = string.gsub(name,'مهر','⸙ ¦ ما اسم صغير الحصان ؟\n1- مهر\n2- جرو\n3- عجل')
name = string.gsub(name,'الدولفين','⸙ ¦ ما الحيوان الذي ينام واحدى عينه مفتوحه ؟\n1- القرش\n2- الدولفين\n3- الثعلب\n')
name = string.gsub(name,'اوروبا','⸙ ¦ ماهي القاره التي تلقب بالقاره العجوز ؟\n1- اوروبا\n2- امريكا الشماليه\n3- افريقيا')
name = string.gsub(name,'الزئبق','⸙ ¦ ما اسم المعدن الموجود فيي الحاله السائله ؟\n1- النحاس\n2- الحديد\n3- الزئبق')
name = string.gsub(name,'لندن','⸙ ¦ ماهي عاصمه انجلترا ؟\n1- لندن\n2- لفرسول\n3- تركيا')
name = string.gsub(name,'الانسان','⸙ ¦ ماهو الشئ الذي برأسه سبع فتحات ؟\n1- الهاتف\n2- التلفاز\n3- الانسان')
name = string.gsub(name,'طوكيو','⸙ ¦ ماهي عاصمه اليابان ؟\n1- بانكول\n2- نيو دلهي\n3- طوكيو')
name = string.gsub(name,'خديجه','⸙ ¦ من هي زوجه الرسول الاكبر منه سنآ ؟\n1- حفضه\n2- زينب\n3- خديجه')
HidTwixTEAM = name..'\n⸙ ¦ ارسل الجواب الصحيح فقط'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
return false
end end
if text == DevHid:get(Twix..'Hid:GameNum8'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Games:Ids'..msg.chat_id_) then 
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_, 1)  
DevHid:del(Twix..'Hid:GameNum8'..msg.chat_id_)
HidTwixTEAM = '⸙ ¦ مبروك لقد ربحت في اللعبه \n⸙ ¦ ارسل 𓄂 الاسئله للعب مره اخرى'
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md')
end
DevHid:set(Twix..'Hid:Games:Ids'..msg.chat_id_,true)
end  
--     Source Twix     --
if DevHid:get(Twix.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
Dev_Hid(msg.chat_id_, msg.id_, 1,"⸙ ¦ عذرا لا يمكنك تخمين عدد اكبر من الـ20 خمن رقم ما بين الـ1 والـ20", 1, 'md')
return false  end 
local GETNUM = DevHid:get(Twix.."GAMES:NUM"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
DevHid:del(Twix..'Set:Num'..msg.chat_id_..msg.sender_user_id_)
DevHid:del(Twix.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_,5)  
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ *التخمين الصحيح هو* 𓄂 '..NUM..'\n⸙ ¦ *مبروك لقد ربحت وحصلت على 5 نقاط يمكنك استبدالها بالرسائل*', 1, 'md')
elseif tonumber(NUM) ~= tonumber(GETNUM) then
DevHid:incrby(Twix..'Set:Num'..msg.chat_id_..msg.sender_user_id_,1)
if tonumber(DevHid:get(Twix..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) >= 3 then
DevHid:del(Twix..'Set:Num'..msg.chat_id_..msg.sender_user_id_)
DevHid:del(Twix.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ *التخمين الصحيح هو* 𓄂 '..GETNUM..'\n⸙ ¦ *للاسف لقد خسرت حاول مره اخرى لتخمين الرقم الصحيح*', 1, 'md')
else
if tonumber(DevHid:get(Twix..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) == 1 then
SetNum = 'محاولتان فقط'
elseif tonumber(DevHid:get(Twix..'Set:Num'..msg.chat_id_..msg.sender_user_id_)) == 2 then
SetNum = 'محاوله واحده فقط'
end
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لقد خمنت الرقم الخطا وتبقى لديك '..SetNum..' ارسل رقم تخمنه مره اخرى للفوز', 1, 'md')
end
end
end
end
if text == 'خمن' and ChCheck(msg) or text == 'تخمين' and ChCheck(msg) then   
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
Num = math.random(1,20)
DevHid:set(Twix.."GAMES:NUM"..msg.chat_id_,Num) 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ اهلا بك عزيزي في لعبة التخمين 𓄂 ⤈\n ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ سيتم تخمين عدد ما بين الـ1 والـ20 اذا تعتقد انك تستطيع الفوز جرب واللعب الان .\n⸙ ¦ ملاحظه لديك ثلاث محاولات فقط فكر قبل ارسال تخمينك !', 1, 'md')
DevHid:setex(Twix.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
end
--     Source Twix     --
if text == 'روليت' then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
DevHid:del(Twix.."Hid:NumRolet"..msg.chat_id_..msg.sender_user_id_) 
DevHid:del(Twix..'Hid:ListRolet'..msg.chat_id_)  
DevHid:setex(Twix.."Hid:StartRolet"..msg.chat_id_..msg.sender_user_id_,3600,true)  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ حسنا لنلعب , ارسل عدد اللاعبين للروليت .', 1, 'md')
return false  
end
end
if text and text:match("^(%d+)$") and DevHid:get(Twix.."Hid:StartRolet"..msg.chat_id_..msg.sender_user_id_) then
if text == "1" then
Text = "⸙ ¦ لا استطيع بدء اللعبه بلاعب واحد فقط"
else
DevHid:set(Twix.."Hid:NumRolet"..msg.chat_id_..msg.sender_user_id_,text)  
Text = '⸙ ¦ تم بدء تسجيل اللسته يرجى ارسال المعرفات \n⸙ ¦ الفائز يحصل على 5 نقاط عدد المطلوبين 𓄂 '..text..' لاعب'
end
DevHid:del(Twix.."Hid:StartRolet"..msg.chat_id_..msg.sender_user_id_)
send(msg.chat_id_,msg.id_,Text)
return false
end
if text and text:match('^(@[%a%d_]+)$') and DevHid:get(Twix.."Hid:NumRolet"..msg.chat_id_..msg.sender_user_id_) then 
if DevHid:sismember(Twix..'Hid:ListRolet'..msg.chat_id_,text) then
send(msg.chat_id_,msg.id_,'⸙ ¦ المعرف 𓄂 ['..text..'] موجود اساسا')
return false
end
tdcli_function ({ID = "SearchPublicChat",username_ = text},function(extra, res, success) 
if res and res.message_ and res.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ المعرف غير صحيح يرجى ارسال معرف صحيح', 1, 'md')
return false 
end
DevHid:sadd(Twix..'Hid:ListRolet'..msg.chat_id_,text)
local CountAdd = DevHid:get(Twix.."Hid:NumRolet"..msg.chat_id_..msg.sender_user_id_)
local CountAll = DevHid:scard(Twix..'Hid:ListRolet'..msg.chat_id_)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
DevHid:del(Twix.."Hid:NumRolet"..msg.chat_id_..msg.sender_user_id_) 
DevHid:setex(Twix.."Hid:WittingStartRolet"..msg.chat_id_..msg.sender_user_id_,1400,true) 
local Text = "⸙ ¦ تم ادخال المعرف 𓄂 ["..text.."]\n⸙ ¦ وتم اكتمال العدد الكلي هل انت مستعد ؟"
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/YesRolet"},{text="لا",callback_data="/NoRolet"}},{{text="اللاعبين",callback_data="/ListRolet"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end 
local Text = "⸙ ¦ تم ادخال المعرف 𓄂 ["..text.."] وتبقى 𓄂 "..CountUser.." لاعبين ليكتمل العدد ارسل المعرف الاخر"
keyboard = {} 
keyboard.inline_keyboard = {{{text="الغاء",callback_data="/NoRolet"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end,nil) 
end
--     Source Twix     --
if text == 'كت تويت' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
local HidTwixTEAM = {
'آخر مرة زرت مدينة الملاهي؟','آخر مرة أكلت أكلتك المفضّلة؟','الوضع الحالي؟\n‏1. سهران\n‏2. ضايج\n‏3. أتأمل','آخر شيء ضاع منك؟','كلمة أخيرة لشاغل البال؟','طريقتك المعتادة في التخلّص من الطاقة السلبية؟','شهر من أشهر العام له ذكرى جميلة معك؟','كلمة غريبة من لهجتك ومعناها؟🤓','‏- شيء سمعته عالق في ذهنك هاليومين؟','متى تكره الشخص الذي أمامك حتى لو كنت مِن أشد معجبينه؟','‏- أبرز صفة حسنة في صديقك المقرب؟','هل تشعر أن هنالك مَن يُحبك؟','اذا اكتشفت أن أعز أصدقائك يضمر لك السوء، موقفك الصريح؟','أجمل شيء حصل معك خلال هاليوم؟','صِف شعورك وأنت تُحب شخص يُحب غيرك؟👀💔','كلمة لشخص غالي اشتقت إليه؟💕','آخر خبر سعيد، متى وصلك؟','أنا آسف على ....؟','أوصف نفسك بكلمة؟','صريح، مشتاق؟','‏- صريح، هل سبق وخذلت أحدهم ولو عن غير قصد؟','‏- ماذا ستختار من الكلمات لتعبر لنا عن حياتك التي عشتها الى الآن؟💭','‏- فنان/ة تود لو يدعوكَ على مائدة عشاء؟😁❤','‏- تخيّل شيء قد يحدث في المستقبل؟','‏- للشباب | آخر مرة وصلك غزل من فتاة؟🌚','شخص أو صاحب عوضك ونساك مُر الحياة ما اسمه ؟','| اذا شفت حد واعجبك وعندك الجرأه انك تروح وتتعرف عليه ، مقدمة الحديث شو راح تكون ؟.','كم مره تسبح باليوم','نسبة النعاس عندك حاليًا؟','لو فقط مسموح شخص واحد تتابعه فالسناب مين بيكون ؟','يهمك ملابسك تكون ماركة ؟','وش الشيء الي تطلع حرتك فيه و زعلت ؟','عندك أخوان او خوات من الرضاعة؟','عندك معجبين ولا محد درا عنك؟',
'أطول مدة قضيتها بعيد عن أهلك ؟','لو يجي عيد ميلادك تتوقع يجيك هدية؟','يبان عليك الحزن من " صوتك - ملامحك','وين تشوف نفسك بعد سنتين؟','وش يقولون لك لما تغني ؟','عندك حس فكاهي ولا نفسية؟','كيف تتصرف مع الشخص الفضولي ؟','كيف هي أحوال قلبك؟','حاجة تشوف نفسك مبدع فيها ؟','متى حبيت؟','شيء كل م تذكرته تبتسم ...','العلاقه السريه دايماً تكون حلوه؟','صوت مغني م تحبه','لو يجي عيد ميلادك تتوقع يجيك هدية؟','اذا احد سألك عن شيء م تعرفه تقول م اعرف ولا تتفلسف ؟','مع او ضد : النوم افضل حل لـ مشاكل الحياة؟','مساحة فارغة (..............) اكتب اي شيء تبين','اغرب اسم مر عليك ؟','عمرك كلمت فويس احد غير جنسك؟','اذا غلطت وعرفت انك غلطان تحب تعترف ولا تجحد؟','لو عندك فلوس وش السيارة اللي بتشتريها؟','وش اغبى شيء سويته ؟','شيء من صغرك ماتغير فيك؟','وش نوع الأفلام اللي تحب تتابعه؟','وش نوع الأفلام اللي تحب تتابعه؟','تجامل احد على حساب مصلحتك ؟','تتقبل النصيحة من اي شخص؟','كلمه ماسكه معك الفترة هذي ؟','متى لازم تقول لا ؟','اكثر شيء تحس انه مات ف مجتمعنا؟','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','هل تعتقد أن هنالك من يراقبك بشغف؟','اشياء اذا سويتها لشخص تدل على انك تحبه كثير ؟','اشياء صعب تتقبلها بسرعه ؟','اقتباس لطيف؟','أكثر جملة أثرت بك في حياتك؟','عندك فوبيا من شيء ؟.',
'اكثر لونين تحبهم مع بعض؟','أجمل بيت شعر سمعته ...','سبق وراودك شعور أنك لم تعد تعرف نفسك؟','تتوقع فيه احد حاقد عليك ويكرهك ؟','أجمل سنة ميلادية مرت عليك ؟','لو فزعت/ي لصديق/ه وقالك مالك دخل وش بتسوي/ين؟','وش تحس انك تحتاج الفترة هاذي ؟','يومك ضاع على؟','@منشن .. شخص تخاف منه اذا عصب ...','فيلم عالق في ذهنك لا تنساه مِن روعته؟','تختار أن تكون غبي أو قبيح؟','الفلوس او الحب ؟','أجمل بلد في قارة آسيا بنظرك؟','ما الذي يشغل بالك في الفترة الحالية؟','احقر الناس هو من ...','وين نلقى السعاده برايك؟','اشياء تفتخر انك م سويتها ؟','تزعلك الدنيا ويرضيك ؟','وش الحب بنظرك؟','افضل هديه ممكن تناسبك؟','كم في حسابك البنكي ؟','كلمة لشخص أسعدك رغم حزنك في يومٍ من الأيام ؟','عمرك انتقمت من أحد ؟!','ما السيء في هذه الحياة ؟','غنية عندك معاها ذكريات🎵🎻','/','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فيه ...','أطول مدة نمت فيها كم ساعة؟','أصعب قرار ممكن تتخذه ؟','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فيه ...','أنت محبوب بين الناس؟ ولاكريه؟','إحساسك في هاللحظة؟','اخر شيء اكلته ؟','تشوف الغيره انانيه او حب؟','اذكر موقف ماتنساه بعمرك؟','اكثر مشاكلك بسبب ؟','اول ماتصحى من النوم مين تكلمه؟','آخر مرة ضحكت من كل قلبك؟','لو الجنسية حسب ملامحك وش بتكون جنسيتك؟','اكثر شيء يرفع ضغطك','اذكر موقف ماتنساه بعمرك؟','لو قالوا لك  تناول صنف واحد فقط من الطعام لمدة شهر .',
'كيف تشوف الجيل ذا؟','ردة فعلك لو مزح معك شخص م تعرفه ؟','احقر الناس هو من ...','تحب ابوك ولا امك','آخر فيلم مسلسل والتقييم🎥؟','أقبح القبحين في العلاقة: الغدر أو الإهمال🤷🏼؟','كلمة لأقرب شخص لقلبك🤍؟','حط@منشن لشخص وقوله "حركتك مالها داعي"😼!','اذا جاك خبر مفرح اول واحد تعلمه فيه مين💃🏽؟','طبع يمكن يخليك تكره شخص حتى لو كنت تُحبه🙅🏻‍♀️؟','افضل ايام الاسبوع عندك🔖؟','يقولون ان الحياة دروس ، ماهو أقوى درس تعلمته من الحياة🏙؟','تاريخ لن تنساه📅؟','تحب الصيف والا الشتاء❄️☀️؟','شخص تحب تستفزه😈؟','شنو ينادونك وانت صغير (عيارتك)👼🏻؟','عقل يفهمك/ج ولا قلب يحبك/ج❤️؟','اول سفره لك وين رح تكون✈️؟','كم عدد اللي معطيهم بلوك👹؟','نوعية من الأشخاص تتجنبهم في حياتك❌؟','شاركنا صورة او فيديو من تصويرك؟📸','كم من عشره تعطي حظك📩؟','اكثر برنامج تواصل اجتماعي تحبه😎؟','من اي دوله انت🌍؟','اكثر دوله ودك تسافر لها🏞؟','مقولة "نكبر وننسى" هل تؤمن بصحتها🧓🏼؟','تعتقد فيه أحد يراقبك👩🏼‍💻؟','لو بيدك تغير الزمن ، تقدمه ولا ترجعه🕰؟','مشروبك المفضل🍹؟','‏قم بلصق آخر اقتباس نسخته؟💭','كم وزنك/ج طولك/ج؟🌚','كم كان عمرك/ج قبل ٨ سنين😈؟','دوله ندمت انك سافرت لها😁؟','لو قالو لك ٣ أمنيات راح تتحقق عالسريع شنو تكون🧞‍♀️؟','‏- نسبة احتياجك للعزلة من 10📊؟','شخص تحبه حظرك بدون سبب واضح، ردة فعلك🧐؟','مبدأ في الحياة تعتمد عليه دائما🕯؟'
}  
Dev_Hid(msg.chat_id_, msg.id_, 1, ''..HidTwixTEAM[math.random(#HidTwixTEAM)]..'' , 1, 'md')  
return false
end
end
--     Source Twix     --
if text == 'الالعاب' and ChCheck(msg) or text == 'العاب' and ChCheck(msg) or text == 'اللعبه' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Games'..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1,[[
⸙ ¦ قائمة العاب المجموعه 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ لعبة التخمين 𓄂 خمن
⸙ ¦ لعبة الامثله 𓄂 امثله
⸙ ¦ لعبة العكس 𓄂 العكس
⸙ ¦ لعبة الاسئله 𓄂 اسئله
⸙ ¦ لعبة الروليت 𓄂 روليت
⸙ ¦ لعبة الحزوره 𓄂 حزوره
⸙ ¦ لعبة الترتيب 𓄂 ترتيب
⸙ ¦ لعبة المعاني 𓄂 معاني
⸙ ¦ لعبة التويت 𓄂 كت تويت
⸙ ¦ لعبة المختلف 𓄂 المختلف
⸙ ¦ لعبة السمايلات 𓄂 سمايلات
⸙ ¦ لعبة المحيبس 𓄂 المحيبس
⸙ ¦ لعبة الرياضيات 𓄂 رياضيات
⸙ ¦ لعبة الانكليزيه 𓄂 انكليزيه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ نقاطي • بيع نقاطي
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]], 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عذرا الالعاب معطله في المجموعه', 1, 'md')
end
end
--     Source Twix     --
if text == 'بيع نقاطي' and ChCheck(msg) then
if tonumber((DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)) == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لم تربح اي نقطه\n⸙ ¦ ارسل 𓄂 الالعاب للعب', 1, 'md')
else
DevHid0 = (DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_) * 50)
DevHid:incrby(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_,DevHid0)
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ تم بيع '..(DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_))..' من نقاطك\n⸙ ¦ كل نقطه تساوي 50 رساله', 'md')
DevHid:del(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_)
end
end
--     Source Twix     --
if text == 'رفع المشرفين' and ChCheck(msg) or text == 'رفع الادمنيه' and ChCheck(msg) then  
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 200},function(arg,abbas) 
DevHid:del(Twix..'Hid:HidConstructor:'..msg.chat_id_)
local num = 0
local admins = abbas.members_  
for i=0 , #admins do   
if abbas.members_[i].bot_info_ == false and abbas.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)   
num = num + 1
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,dp) 
if dp.first_name_ == false then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)   
end
end,nil)   
else
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)   
end 
if abbas.members_[i].status_.ID == "ChatMemberStatusCreator" then  
Manager_id = admins[i].user_id_  
DevHid:sadd(Twix..'Hid:BasicConstructor:'..msg.chat_id_,Manager_id)  
DevHid:sadd(Twix..'Hid:HidConstructor:'..msg.chat_id_,Manager_id)   
end  
end  
if num == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لا يوجد ادمنيه ليتم رفعهم\n⸙ ¦ تم رفع منشئ المجموعه", 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم رفع '..num..' من الادمنيه \n⸙ ¦ تم رفع منشئ المجموعه', 1, 'md')
end
end,nil) 
end
--     Source Twix     --
if text == 'غادر' and SudoBot(msg) then
if DevHid:get(Twix.."Hid:Left:Bot"..Twix) and not SecondSudo(msg) then
Dev_Hid(msg.chat_id_,msg.id_, 1, "⸙ ¦ المغادره معطله من قبل المطور الاساسي", 1, 'md')
return false  
end
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم مغادرة المجموعه \n⸙ ¦ تم حذف جميع بياناتها ', 1, 'md')
ChatLeave(msg.chat_id_, Twix)
DevHid:srem(Twix.."Hid:Groups",msg.chat_id_)
end
--     Source Twix     --
if text ==('موقعي') and ChCheck(msg) then
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
rtpa = 'المنشئ'
elseif da.status_.ID == "ChatMemberStatusEditor" then
rtpa = 'الادمن'
elseif da.status_.ID == "ChatMemberStatusMember" then
rtpa = 'عضو'
end
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ موقعك 𓄂 '..rtpa, 1, 'md')
end,nil)
end
--     Source Twix     --
if text == "معلوماتي" and ChCheck(msg) then
function get_me(extra,result,success)
local msguser = tonumber(DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_))
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local cont = (tonumber(DevHid:get(Twix..'Hid:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0)
local user_nkt = tonumber(DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)
if result.username_ then username = '@'..result.username_ else username = 'لا يوجد' end
if result.last_name_ then lastname = result.last_name_ else lastname = '' end
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ اسمك 𓄂 ❨ ['..result.first_name_..'] ❩\n⸙ ¦ معرفك 𓄂 ❨ ['..username..'] ❩\n⸙ ¦ ايديك 𓄂 ❨ `'..result.id_..'` ❩\n⸙ ¦ نقاطك 𓄂 ❨ '..user_nkt..' ❩\n⸙ ¦ رسائلك 𓄂 ❨ '..user_msgs..' ❩\n⸙ ¦ جهاتك 𓄂 ❨ '..cont..' ❩\n⸙ ¦ تفاعلك 𓄂 '..formsgs(msguser)..'\n⸙ ¦ رتبتك 𓄂 '..IdRank(msg.sender_user_id_, msg.chat_id_), 1, 'md')
end
getUser(msg.sender_user_id_,get_me)
end
end
--     Source Twix     --
if text == "تعيين قناة الاشتراك" or text == "تغيير قناة الاشتراك" or text == "تعيين الاشتراك الاجباري" or text == "وضع قناة الاشتراك" then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
DevHid:setex(Twix..'DevHid4'..msg.sender_user_id_,360,true)
send(msg.chat_id_, msg.id_, '⸙ ¦ ارسل لي معرف قناة الاشتراك الان')
end
return false  
end
if text == "تفعيل الاشتراك الاجباري" then  
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
if DevHid:get(Twix..'DevHid2') then
local DevCh = DevHid:get(Twix..'DevHid3')
send(msg.chat_id_, msg.id_,"⸙ ¦ الاشتراك الاجباري مفعل \n⸙ ¦ على القناة 𓄂 ["..DevCh.."]")
else
DevHid:setex(Twix..'DevHid4'..msg.sender_user_id_,360,true)
send(msg.chat_id_, msg.id_,"⸙ ¦ لاتوجد قناة لتفعيل الاشتراك\n⸙ ¦ ارسل لي معرف قناة الاشتراك الان")
end
end
return false  
end
if text == "تعطيل الاشتراك الاجباري" then  
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
DevHid:del(Twix..'DevHid2') DevHid:del(Twix..'DevHid3')
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الاشتراك الاجباري'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
return false  
end
if text == "حذف قناة الاشتراك" or text == "حذف قناه الاشتراك" then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
DevHid:del(Twix..'DevHid2') DevHid:del(Twix..'DevHid3')
Dev_Hid(msg.chat_id_, msg.id_, 1,"⸙ ¦ تم حذف قناة الاشتراك الاجباري", 1, 'md') 
end
end
if SecondSudo(msg) then
if text == 'جلب قناة الاشتراك' or text == 'قناة الاشتراك' or text == 'الاشتراك الاجباري' or text == 'قناة الاشتراك الاجباري' then
if DevHid:get(Twix..'DevHid3') then
local DevCh = DevHid:get(Twix..'DevHid3')
send(msg.chat_id_, msg.id_, "⸙ ¦ قناة الاشتراك 𓄂 ["..DevCh.."]")
else
send(msg.chat_id_, msg.id_, "⸙ ¦ لاتوجد قناة في الاشتراك الاجباري")
end
return false  
end end
--     Source Twix     --
if SudoBot(msg) then
if text == 'اذاعه للكل بالتوجيه' and tonumber(msg.reply_to_message_id_) > 0 then
function HidTwixTEAM(extra,result,success)
if DevHid:get(Twix.."Hid:Send:Bot"..Twix) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⸙ ¦ الاذاعه معطله من قبل المطور الاساسي")
return false
end
local GpList = DevHid:smembers(Twix.."Hid:Groups")
for k,v in pairs(GpList) do
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = result.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end
local PvList = DevHid:smembers(Twix.."Hid:Users")
for k,v in pairs(PvList) do
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = result.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم اذاعة رسالتك بالتوجيه \n⸙ ¦ ‏في 𓄂 ❨ '..#GpList..' ❩ مجموعه \n⸙ ¦ والى 𓄂 ❨ '..#PvList..' ❩ مشترك \n ✓', 1, 'md')
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),HidTwixTEAM)
end
end
--     Source Twix     --
if text == "مشاهده المنشور" and ChCheck(msg) or text == "مشاهدات المنشور" and ChCheck(msg) or text == "عدد المشاهدات" and ChCheck(msg) then
DevHid:set(Twix..'Hid:viewget'..msg.sender_user_id_,true)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ حسنا قم باعادة توجيه للمنشور الذي تريدني حساب مشاهداته', 1, 'md')
end
--     Source Twix     --
if text == "السورس" or text == "سورس" then 
local text =  [[
Welcome To Source
⸙ ¦ Twix TEAM
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)

⸙ ¦ [Exp Source](https://t.me/i8_88)

⸙ ¦ [Developer](https://t.me/hII3d)
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
--     Source Twix     --
if ChatType == 'sp' or ChatType == 'gp'  then
if text == "اطردني" and ChCheck(msg) or text == "ادفرني" and ChCheck(msg) then
if DevHid:get(Twix.."Hid:Kick:Me"..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عذرا هذه الخاصيه معطله ', 1, 'md')
return false
end
DevHid:set(Twix..'yes'..msg.sender_user_id_..'', 'delyes')
DevHid:set(Twix..'no'..msg.sender_user_id_..'', 'delno')
local Text = '⸙ ¦ هل انت متأكد من المغادره'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/delyes"},{text="لا",callback_data="/delno"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
--     Source Twix     --
if text == 'تعطيل اطردني' and Manager(msg) and ChCheck(msg) then
DevHid:set(Twix.."Hid:Kick:Me"..msg.chat_id_, true)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل امر اطردني'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
if text == 'تفعيل اطردني' and Manager(msg) and ChCheck(msg) then
DevHid:del(Twix.."Hid:Kick:Me"..msg.chat_id_)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل امر اطردني'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
--     Source Twix     --
if text == "نزلني" and ChCheck(msg) then
if DevHid:get(Twix.."Hid:Del:Me"..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عذرا هذه الخاصيه معطله ', 1, 'md')
return false
end
DevHid:set(Twix..'yesdel'..msg.sender_user_id_..'', 'delyes')
DevHid:set(Twix..'nodel'..msg.sender_user_id_..'', 'delno')
local Text = '⸙ ¦ هل انت متأكد من تنزيلك'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/yesdel"},{text="لا",callback_data="/nodel"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
--     Source Twix     --
if text == 'تعطيل نزلني' and BasicConstructor(msg) and ChCheck(msg) then
DevHid:set(Twix.."Hid:Del:Me"..msg.chat_id_, true)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل امر نزلني'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
if text == 'تفعيل نزلني' and BasicConstructor(msg) and ChCheck(msg) then
DevHid:del(Twix.."Hid:Del:Me"..msg.chat_id_)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل امر نزلني'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
--     Source Twix     --
if Admin(msg) then
if text == "تاك للكل" and ChCheck(msg) then
function TagAll(dp1,dp2)
local text = "⸙ ¦ وينكم يالربع \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k, v in pairs(dp2.members_) do
i = i + 1
if DevHid:get(Twix..'Save:UserName'..v.user_id_) then
text = text..""..i.."~ : [@"..DevHid:get(Twix..'Save:UserName'..v.user_id_).."]\n"
else
text = text..""..i.."~ : "..v.user_id_.."\n"
end
end 
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
tdcli_function({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID, offset_ = 0,limit_ = 200000},TagAll,nil)
end
--     Source Twix     --
if text and text:match("^كللهم (.*)$") and ChCheck(msg) then
local txt = {string.match(text, "^(كللهم) (.*)$")}
function TagAll(dp1,dp2)
local text = "⸙ ¦ "..txt[2].." \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k, v in pairs(dp2.members_) do
i = i + 1
if DevHid:get(Twix..'Save:UserName'..v.user_id_) then
text = text..""..i.."~ : [@"..DevHid:get(Twix..'Save:UserName'..v.user_id_).."]\n"
else
text = text..""..i.."~ : "..v.user_id_.."\n"
end
end 
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
tdcli_function({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID, offset_ = 0,limit_ = 200000},TagAll,nil)
end
end
--     Source Twix     --
if text == "رسائلي" and msg.reply_to_message_id_ == 0 and ChCheck(msg) then
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ عدد رسائلك هنا 𓄂 *❨ "..user_msgs.." ❩*", 1, 'md')
end
if text == "التفاعل" and ChCheck(msg) then
local EntryNumber = (DevHid:get(Twix..'Hid:EntryNumber'..msg.chat_id_..':'..os.date('%d')) or 0)
local ExitNumber = (DevHid:get(Twix..'Hid:ExitNumber'..msg.chat_id_..':'..os.date('%d')) or 0)
local MsgNumberDay = (DevHid:get(Twix..'Hid:MsgNumberDay'..msg.chat_id_..':'..os.date('%d')) or 0)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ انضمام الاعضاء اليوم 𓄂 *"..EntryNumber.."*\n⸙ ¦ مغادرة الاعضاء اليوم 𓄂 *"..ExitNumber.."*\n⸙ ¦ عدد الرسائل اليوم 𓄂 *"..MsgNumberDay.."*\n⸙ ¦ نسبة التفاعل اليوم 𓄂 *"..math.random(40,100).."%*", 1, 'md')
end
--     Source Twix     --
if text == "معرفي" and ChCheck(msg) then
function get_username(extra,result,success)
text = '⸙ ¦ معرفك 𓄂 ❨ User ❩'
local text = text:gsub('User',('@'..result.username_ or ''))
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
getUser(msg.sender_user_id_,get_username)
end
if text == "اسمي" and ChCheck(msg) then
function get_firstname(extra,result,success)
text = '⸙ ¦ اسمك 𓄂 firstname lastname'
local text = text:gsub('firstname',(result.first_name_ or ''))
local text = text:gsub('lastname',(result.last_name_ or ''))
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
getUser(msg.sender_user_id_,get_firstname)
end   
--     Source Twix     --
if text == "اهمس" or text == "همسه" or text == "اريد بوت الهمسه" or text == "دزلي بوت الهمسه" or  text == "دزولي بوت الهمسه" then  Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ @HMSEBOT', 1, 'md') end
if text == "رابط حذف" or text == "رابط الحذف" or text == "اريد رابط الحذف" or  text == "شمرلي رابط الحذف" or text == "اريد رابط حذف" then local inline = {{{text="اضغط هنا",url="https://t.me/DYFBOT"}}} SendInline(msg.chat_id_,'⸙ ¦ اضغط للحصول على الرابط',nil,inline) return false end
if text == "بوت الحذف" or text == "اريد بوت الحذف" or text == "اريد بوت حذف" or text == "بوت حذف" or text == "بوت حذف حسابات" or text == "راح احذف" then local inline = {{{text="اضغط هنا",url="https://t.me/DYFBOT"}}} SendInline(msg.chat_id_,'⸙ ¦ اضغط للحصول على البوت',nil,inline) return false end
if text == "جهاتي" and ChCheck(msg) or text == "اضافاتي" and ChCheck(msg) then add = (tonumber(DevHid:get(Twix..'Hid:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0) Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ عدد جهاتك المضافه 𓄂 *❨ "..add.." ❩* ", 1, 'md') end
if text == "تعديلاتي" or text == "سحكاتي" and ChCheck(msg) then local edit_msg = DevHid:get(Twix..'Hid:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0  Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ عدد تعديلاتك 𓄂 *❨ "..edit_msg.." ❩* ", 1, 'md') end
if text == "ايديي" and ChCheck(msg) then Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ ايديك 𓄂 ❨ `'..msg.sender_user_id_..'` ❩', 1, 'md') end
if text == "رتبتي" and ChCheck(msg) then Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ رتبتك 𓄂 '..IdRank(msg.sender_user_id_, msg.chat_id_), 1, 'html') end
if text == "ايدي المجموعه" and ChCheck(msg) then Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ايدي المجموعه 𓄂 `"..msg.chat_id_.."`", 1, 'md') end
if text == 'مسح سحكاتي' or text == 'مسح تعديلاتي' or text == 'حذف سحكاتي' or text == 'حذف تعديلاتي' then DevHid:del(Twix..'Hid:EditMsg'..msg.chat_id_..msg.sender_user_id_) Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حذف جميع تعديلاتك بنجاح' , 1, 'md') end
if text == 'مسح جهاتي' or text == 'مسح اضافاتي' or text == 'حذف جهاتي' or text == 'حذف اضافاتي' then DevHid:del(Twix..'Hid:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_) Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حذف جميع جهاتك المضافه' , 1, 'md') end
--     Source Twix     --
if text == "المطور" then 
local DevCh1 = DevHid:get(Twix.."DevHid3")
local DevText = DevHid:get(Twix.."DevText")
if DevCh1 then DevCh = '\n⸙ ¦ *Dev Ch* ↬ ['..DevCh1..']' else DevCh = '' end
tdcli_function({ID="GetUser",user_id_=DevId},function(arg,dp) 
if dp.username_ ~= false then DevUser = '@'..dp.username_ else DevUser = dp.first_name_ end
if DevText then
Dev_Hid(msg.chat_id_, msg.id_, 1, DevText, 1, "md")
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *Dev User* ↬ ['..DevUser..']\n⸙ ¦ *Dev Id* ↬ '..DevId..''..DevCh, 1, "md")
end
end,nil)
end 
--     Source Twix     --
if text and text:match('^هينه @(.*)') and ChCheck(msg) or text and text:match('^هينها @(.*)') then 
if not DevHid:get(Twix..'Hid:Lock:Stupid'..msg.chat_id_) then
local username = text:match('^هينه @(.*)') or text:match('^هينها @(.*)') 
function HidTwixTEAM(extra,result,success)
if result.id_ then  
if tonumber(result.id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, 'شو تمضرط اكو واحد يهين نفسه؟🤔👌🏿', 1, 'md')  
return false 
end  
if tonumber(result.id_) == tonumber(DevId) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md') 
return false  
end  
if tonumber(result.id_) == tonumber(1923405236) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md') 
return false  
end  
if DevHid:sismember(Twix.."Hid:HidConstructor:"..msg.chat_id_,result.id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
local HidTwixTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md') 
local HidTwixTEAM = { "لكك جرجف @"..username.." احترم اسيادكك لا اكتلكك وازربب على كبركك،💩🖐🏿","هشش لكك فاشل @"..username.." لتضل تمسلت لا اخربط تضاريس وجهك جنه ابط عبده، 😖👌🏿","حبيبي @"..username.." راح احاول احترمكك هالمره بلكي تبطل حيونه، 🤔🔪","دمشي لك @"..username.." ينبوع الفشل مو زين ملفيك ونحجي وياك هي منبوذ 😏🖕🏿","ها الغليض التفس ابو راس المربع @"..username.." متعلملك جم حجايه وجاي تطكطكهن علينه دبطل😒🔪",}
Dev_Hid(msg.chat_id_, result.id_, 1,''..HidTwixTEAM[math.random(#HidTwixTEAM)]..'', 1, 'html') 
else  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو غير موجود في المجموعه', 1, 'md') 
end 
end 
resolve_username(username,HidTwixTEAM)
end
end
--     Source Twix     --
if text == ("هينه") or text == ("بعد هينه") or text == ("هينه بعد") or text == ("لك هينه") or text == ("هينها") or text == ("هينهه") or text == ("رزله") or text == ("رزلهه") or text == ("رزلها") then
if not DevHid:get(Twix..'Hid:Lock:Stupid'..msg.chat_id_) then
function hena(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(Twix) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, 'شو تمضرط اكو واحد يهين نفسه؟🤔👌🏿', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
if tonumber(result.sender_user_id_) == tonumber(1923405236) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
if DevHid:sismember(Twix.."Hid:HidConstructor:"..msg.chat_id_,result.sender_user_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, 'دي لكك تريد اهينن تاج راسكك؟😏🖕🏿', 1, 'md')
return false
end 
local HidTwixTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md') 
local HidTwixTEAM = {"لكك جرجف احترم اسيادكك لا اكتلكك وازربب على كبركك،💩🖐🏿","هشش فاشل لتضل تمسلت لا اخربط تضاريس وجهك جنه ابط عبده، 😖👌🏿","دمشي لك ينبوع الفشل مو زين ملفيك ونحجي وياك هي منبوذ 😏🖕🏿","ها الغليض التفس ابو راس المربع متعلملك جم حجايه وجاي تطكطكهن علينه دبطل😒🔪","حبيبي راح احاول احترمكك هالمره بلكي تبطل حيونه، 🤔🔪"} 
Dev_Hid(msg.chat_id_, result.id_, 1,''..HidTwixTEAM[math.random(#HidTwixTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),hena)   
end
end
end
if text == ("بوسه") or text == ("بعد بوسه") or text == ("ضل بوس") or text == ("بوسه بعد") or text == ("بوسها") or text == ("بعد بوسها") or text == ("ضل بوس") or text == ("بوسها بعد") or text == ("بوسهه") then
if not DevHid:get(Twix..'Hid:Lock:Stupid'..msg.chat_id_) then
function bosh(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(Twix) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح ابوس نفسيي؟😶💔', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Hid(msg.chat_id_, result.id_, 1, 'مواححح احلاا بوسةة المطوريي😻🔥💗', 1, 'html')
return false
end 
local HidTwixTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md') 
local HidTwixTEAM = {"مواححح افيش عافيههه😍🔥💗","امممووااهحح شهلعسل🥺🍯💘","مواححح،ءوفف اذوب🤤💗"} 
Dev_Hid(msg.chat_id_, result.id_, 1,''..HidTwixTEAM[math.random(#HidTwixTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),bosh)   
end
end
end
if text == ("صيحه") or text == ("صيحها") or text == ("صيحهه") or text == ("صيح") then
if not DevHid:get(Twix..'Hid:Lock:Stupid'..msg.chat_id_) then
function seha(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(Twix) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح اصيح نفسيي؟😶💔', 1, 'md') 
return false  
end  
if tonumber(result.sender_user_id_) == tonumber(DevId) then  
Dev_Hid(msg.chat_id_, result.id_, 1, 'تعال مطوريي محتاجيكك🏃🏻‍♂️♥️', 1, 'html')
return false
end 
local HidTwixTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md') 
local HidTwixTEAM = {"تتعال ححب محتاجيك🙂🍭","تعال يولل استاذكك ايريدككك😒🔪","يمعوود تعاال يريدوكك🤕♥️","تعال لكك ديصيحوك😐🖤"} 
Dev_Hid(msg.chat_id_, result.id_, 1,''..HidTwixTEAM[math.random(#HidTwixTEAM)]..'', 1, 'md') 
end 
if tonumber(msg.reply_to_message_id_) == 0 then
else 
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),seha)   
end
end
end
--     Source Twix     --
if text and text:match('^صيحه @(.*)') and ChCheck(msg) or text and text:match('^صيح @(.*)') and ChCheck(msg) then 
if not DevHid:get(Twix..'Hid:Lock:Stupid'..msg.chat_id_) then
local username = text:match('^صيحه @(.*)') or text:match('^صيح @(.*)') 
function HidTwixTEAM(extra,result,success)
if result.id_ then  
if tonumber(result.id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, 'فهمنيي شلوون راحح اصيح نفسيي؟😶💔', 1, 'md')  
return false 
end  
if tonumber(result.id_) == tonumber(DevId) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, 'تعال مطوريي محتاجيكك🏃🏻‍♂️♥️ @'..username, 1, 'html') 
return false  
end  
local HidTwixTEAM = "صارر ستاذيي 🏃🏻‍♂️♥️" 
Dev_Hid(msg.chat_id_, msg.id_, 1,HidTwixTEAM, 1, 'md') 
local HidTwixTEAM = { "تتعال ححب @"..username.." محتاجيك🙂🍭","تعال يولل @"..username.." استاذكك ايريدككك😒🔪","يمعوود @"..username.." تعاال يريدوكك🤕♥️","تعال لكك @"..username.." ديصيحوك😐🖤",}
Dev_Hid(msg.chat_id_, result.id_, 1,''..HidTwixTEAM[math.random(#HidTwixTEAM)]..'', 1, 'html') 
else  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العضو غير موجود في المجموعه', 1, 'md') 
end 
end 
resolve_username(username,HidTwixTEAM)
end
end
end
--     Source Twix     --
if text == ("تنزيل الكل") and msg.reply_to_message_id_ ~= 0 and Manager(msg) and ChCheck(msg) then 
function promote_by_reply(extra, result, success)
if SudoId(result.sender_user_id_) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لاتستطيع تنزيل المطور الاساسي", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',result.sender_user_id_) then
secondsudo = 'المطورين الثانويين • ' else secondsudo = '' end
if DevHid:sismember(Twix..'Hid:SudoBot:',result.sender_user_id_) then
sudobot = 'المطورين • ' else sudobot = '' end
if DevHid:sismember(Twix..'Hid:ManagerAll:',result.sender_user_id_) then
managerall = 'المدراء العامين • ' else managerall = '' end
if DevHid:sismember(Twix..'Hid:AdminAll:',result.sender_user_id_) then
adminall = 'الادمنيه العامين • ' else adminall = '' end
if DevHid:sismember(Twix..'Hid:VipAll:',result.sender_user_id_) then
vpall = 'المميزين العامين • ' else vpall = '' end
if DevHid:sismember(Twix..'Hid:BasicConstructor:'..msg.chat_id_, result.sender_user_id_) then
basicconstructor = 'المنشئين الاساسيين • ' else basicconstructor = '' end
if DevHid:sismember(Twix..'Hid:Constructor:'..msg.chat_id_, result.sender_user_id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevHid:sismember(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_) then
manager = 'المدراء • ' else manager = '' end
if DevHid:sismember(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevHid:sismember(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevHid:sismember(Twix..'Hid:Cleaner:'..msg.chat_id_, result.sender_user_id_) then
cleaner = 'المنظفين • ' else cleaner = ''
end
if RankChecking(result.sender_user_id_,msg.chat_id_) ~= false then
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من 𓄂 ⤈\n~ ( "..secondsudo..''..sudobot..''..managerall..''..adminall..''..vpall..''..basicconstructor..''..constructor..''..manager..''..admins..''..vipmem..''..cleaner.." ) ~")  
else 
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ لم تتم ترقيته مسبقا")  
end
if HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudoid' then
DevHid:srem(Twix..'Hid:SecondSudo:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:SudoBot:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:ManagerAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:AdminAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'secondsudo' then
DevHid:srem(Twix..'Hid:SudoBot:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:ManagerAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:AdminAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudobot' then
DevHid:srem(Twix..'Hid:ManagerAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:AdminAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'Hidconstructor' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'basicconstructor' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.sender_user_id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'constructor' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.sender_user_id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'manager' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.sender_user_id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.sender_user_id_)
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and text:match("^تنزيل الكل @(.*)$") and Manager(msg) and ChCheck(msg) then
local rem = {string.match(text, "^(تنزيل الكل) @(.*)$")}
function remm(extra, result, success)
if result.id_ then
if SudoId(result.id_) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لاتستطيع تنزيل المطور الاساسي", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',result.id_) then
secondsudo = 'المطورين الثانويين • ' else secondsudo = '' end
if DevHid:sismember(Twix..'Hid:SudoBot:',result.id_) then
sudobot = 'المطورين • ' else sudobot = '' end
if DevHid:sismember(Twix..'Hid:ManagerAll:',result.id_) then
managerall = 'المدراء العامين • ' else managerall = '' end
if DevHid:sismember(Twix..'Hid:AdminAll:',result.id_) then
adminall = 'الادمنيه العامين • ' else adminall = '' end
if DevHid:sismember(Twix..'Hid:VipAll:',result.id_) then
vpall = 'المميزين العامين • ' else vpall = '' end
if DevHid:sismember(Twix..'Hid:BasicConstructor:'..msg.chat_id_, result.id_) then
basicconstructor = 'المنشئين الاساسيين • ' else basicconstructor = '' end
if DevHid:sismember(Twix..'Hid:Constructor:'..msg.chat_id_, result.id_) then
constructor = 'المنشئين • ' else constructor = '' end 
if DevHid:sismember(Twix..'Hid:Managers:'..msg.chat_id_, result.id_) then
manager = 'المدراء • ' else manager = '' end
if DevHid:sismember(Twix..'Hid:Admins:'..msg.chat_id_, result.id_) then
admins = 'الادمنيه • ' else admins = '' end
if DevHid:sismember(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_) then
vipmem = 'المميزين • ' else vipmem = '' end
if DevHid:sismember(Twix..'Hid:Cleaner:'..msg.chat_id_, result.id_) then
cleaner = 'المنظفين • ' else cleaner = ''
end
if RankChecking(result.id_,msg.chat_id_) ~= false then
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من 𓄂 ⤈\n~ ( "..secondsudo..''..sudobot..''..managerall..''..adminall..''..vpall..''..basicconstructor..''..constructor..''..manager..''..admins..''..vipmem..''..cleaner.." ) ~")  
else 
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ لم تتم ترقيته مسبقا")  
end 
if HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudoid' then
DevHid:srem(Twix..'Hid:SecondSudo:', result.id_)
DevHid:srem(Twix..'Hid:SudoBot:', result.id_)
DevHid:srem(Twix..'Hid:ManagerAll:', result.id_)
DevHid:srem(Twix..'Hid:AdminAll:', result.id_)
DevHid:srem(Twix..'Hid:VipAll:', result.id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'secondsudo' then
DevHid:srem(Twix..'Hid:SudoBot:', result.id_)
DevHid:srem(Twix..'Hid:ManagerAll:', result.id_)
DevHid:srem(Twix..'Hid:AdminAll:', result.id_)
DevHid:srem(Twix..'Hid:VipAll:', result.id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'sudobot' then
DevHid:srem(Twix..'Hid:ManagerAll:', result.id_)
DevHid:srem(Twix..'Hid:AdminAll:', result.id_)
DevHid:srem(Twix..'Hid:VipAll:', result.id_)
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'Hidconstructor' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'basicconstructor' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.id_)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_, result.id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'constructor' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_, result.id_)
elseif HidDelAll(msg.sender_user_id_,msg.chat_id_) == 'manager' then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, result.id_)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_, result.id_)
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المعرف غير صحيح*', 1, 'md')
end
end
resolve_username(rem[2],remm)
end
--     Source Twix     --
--     Set SecondSudo     --
if Sudo(msg) then
if text ==('اضف مطور ثانوي') or text ==('رفع مطور ثانوي') and ChCheck(msg) then
function sudo_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:SecondSudo:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المطورين الثانويين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)
end end 
if text and (text:match('^اضف مطور ثانوي @(.*)') or text:match('^رفع مطور ثانوي @(.*)')) and ChCheck(msg) then
local username = text:match('^اضف مطور ثانوي @(.*)') or text:match('^رفع مطور ثانوي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:SecondSudo:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المطورين الثانويين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^اضف مطور ثانوي (%d+)') or text:match('^رفع مطور ثانوي (%d+)')) and ChCheck(msg) then
local user = text:match('اضف مطور ثانوي (%d+)') or text:match('رفع مطور ثانوي (%d+)')
DevHid:sadd(Twix..'Hid:SecondSudo:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المطورين الثانويين")  
end
--     Source Twix     --
--     Rem SecondSudo     --
if text ==('حذف مطور ثانوي') or text ==('تنزيل مطور ثانوي') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:SecondSudo:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المطورين الثانويين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and (text:match('^حذف مطور ثانوي @(.*)') or text:match('^تنزيل مطور ثانوي @(.*)')) and ChCheck(msg) then
local username = text:match('^حذف مطور ثانوي @(.*)') or text:match('^تنزيل مطور ثانوي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:SecondSudo:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المطورين الثانويين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^حذف مطور ثانوي (%d+)') or text:match('^تنزيل مطور ثانوي (%d+)')) and ChCheck(msg) then
local user = text:match('حذف مطور ثانوي (%d+)') or text:match('تنزيل مطور ثانوي (%d+)')
DevHid:srem(Twix..'Hid:SecondSudo:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المطورين الثانويين")  
end end
--     Source Twix     --
--       Set SudoBot      --
if SecondSudo(msg) then
if text ==('اضف مطور') or text ==('رفع مطور') and ChCheck(msg) then
function sudo_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:SudoBot:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المطورين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),sudo_reply)
end end 
if text and (text:match('^اضف مطور @(.*)') or text:match('^رفع مطور @(.*)')) and ChCheck(msg) then
local username = text:match('^اضف مطور @(.*)') or text:match('^رفع مطور @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:SudoBot:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المطورين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^اضف مطور (%d+)') or text:match('^رفع مطور (%d+)')) and ChCheck(msg) then
local user = text:match('اضف مطور (%d+)') or text:match('رفع مطور (%d+)')
DevHid:sadd(Twix..'Hid:SudoBot:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المطورين")  
end
--     Source Twix     --
--       Rem SudoBot      --
if text ==('حذف مطور') or text ==('تنزيل مطور') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:SudoBot:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المطورين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and (text:match('^حذف مطور @(.*)') or text:match('^تنزيل مطور @(.*)')) and ChCheck(msg) then
local username = text:match('^حذف مطور @(.*)') or text:match('^تنزيل مطور @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:SudoBot:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المطورين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and (text:match('^حذف مطور (%d+)') or text:match('^تنزيل مطور (%d+)')) and ChCheck(msg) then
local user = text:match('حذف مطور (%d+)') or text:match('تنزيل مطور (%d+)')
DevHid:srem(Twix..'Hid:SudoBot:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المطورين")  
end end
--     Source Twix     --
--      Set ManagerAll    --
if SudoBot(msg) then
if text ==('رفع مدير عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:ManagerAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المدراء العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع مدير عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مدير عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:ManagerAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المدراء العامين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مدير عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع مدير عام (%d+)')
DevHid:sadd(Twix..'Hid:ManagerAll:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المدراء العامين")  
end
--     Source Twix     --
--      Rem ManagerAll    --
if text ==('تنزيل مدير عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:ManagerAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المدراء العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مدير عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مدير عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:ManagerAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المدراء العامين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مدير عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مدير عام (%d+)')
DevHid:srem(Twix..'Hid:ManagerAll:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المدراء العامين")  
end end
--     Source Twix     --
--      Set adminall      --
if ManagerAll(msg) then
if text ==('رفع ادمن عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:AdminAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة الادمنيه العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع ادمن عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع ادمن عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:AdminAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة الادمنيه العامين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع ادمن عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع ادمن عام (%d+)')
DevHid:sadd(Twix..'Hid:AdminAll:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة الادمنيه العامين")  
end
--     Source Twix     --
--      Rem adminall      --
if text ==('تنزيل ادمن عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:AdminAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة الادمنيه العامين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل ادمن عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل ادمن عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:AdminAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة الادمنيه العامين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل ادمن عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل ادمن عام (%d+)')
DevHid:srem(Twix..'Hid:AdminAll:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة الادمنيه العامين")  
end end
--     Source Twix     --
--       Set Vipall       --
if AdminAll(msg) then
if text ==('رفع مميز عام') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:VipAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المميزين العام")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع مميز عام @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مميز عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:VipAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المميزين العام")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مميز عام (%d+)') and ChCheck(msg) then
local user = text:match('رفع مميز عام (%d+)')
DevHid:sadd(Twix..'Hid:VipAll:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المميزين العام")  
end
--     Source Twix     --
--       Rem Vipall       --
if text ==('تنزيل مميز عام') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:VipAll:',result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المميزين العام")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مميز عام @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مميز عام @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:VipAll:',result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المميزين العام")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مميز عام (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مميز عام (%d+)')
DevHid:srem(Twix..'Hid:VipAll:',user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المميزين العام")  
end end
--     Source Twix     --
--  Set BasicConstructor  --
if ChatType == 'sp' or ChatType == 'gp'  then
if HidConstructor(msg) then
if text ==('رفع منشئ اساسي') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه منشئ اساسي")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع منشئ اساسي @(.*)') and ChCheck(msg) then
local username = text:match('^رفع منشئ اساسي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه منشئ اساسي")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منشئ اساسي (%d+)') and ChCheck(msg) then
local user = text:match('رفع منشئ اساسي (%d+)')
DevHid:sadd(Twix..'Hid:BasicConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه منشئ اساسي")  
end
--     Source Twix     --
--  Rem BasicConstructor  --
if text ==('تنزيل منشئ اساسي') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله منشئ اساسي")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منشئ اساسي @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل منشئ اساسي @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله منشئ اساسي")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منشئ اساسي (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل منشئ اساسي (%d+)')
DevHid:srem(Twix..'Hid:BasicConstructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله منشئ اساسي")  
end end
if text ==('رفع منشئ اساسي') and not HidConstructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر لمنشئ المجموعه والمطورين فقط', 1, 'md')
end
--     Source Twix     --
--    Set  Constructor    --
if BasicConstructor(msg) then
if text ==('رفع منشئ') and ChCheck(msg) then
function raf_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:Constructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المنشئين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),raf_reply)
end end
if text and text:match('^رفع منشئ @(.*)') and ChCheck(msg) then
local username = text:match('^رفع منشئ @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:Constructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المنشئين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منشئ (%d+)') and ChCheck(msg) then
local user = text:match('رفع منشئ (%d+)')
DevHid:sadd(Twix..'Hid:Constructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المنشئين")  
end
--     Source Twix     --
--    Rem  Constructor    --
if text ==('تنزيل منشئ') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المنشئين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منشئ @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل منشئ @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المنشئين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منشئ (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل منشئ (%d+)')
DevHid:srem(Twix..'Hid:Constructor:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المنشئين")  
end 
end
--     Source Twix     --
--      Set Manager       --
if Constructor(msg) then
if text ==('رفع مدير') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:Managers:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المدراء")  
end  
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع مدير @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مدير @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:Managers:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المدراء")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end 
if text and text:match('^رفع مدير (%d+)') and ChCheck(msg) then
local user = text:match('رفع مدير (%d+)')
DevHid:sadd(Twix..'Hid:Managers:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المدراء")  
end
--     Source Twix     --
--       Rem Manager      --
if text ==('تنزيل مدير') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المدراء")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مدير @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مدير @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المدراء")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مدير (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مدير (%d+)')
DevHid:srem(Twix..'Hid:Managers:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المدراء")  
end 
--     Source Twix     --
--       Set Cleaner      --
if text ==('رفع منظف') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:sadd(Twix..'Hid:Cleaner:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المنظفين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع منظف @(.*)') and ChCheck(msg) then
local username = text:match('^رفع منظف @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:sadd(Twix..'Hid:Cleaner:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المنظفين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع منظف (%d+)') and ChCheck(msg) then
local user = text:match('رفع منظف (%d+)')
DevHid:sadd(Twix..'Hid:Cleaner:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المنظفين")  
end
--     Source Twix     --
--       Rem Cleaner      --
if text ==('تنزيل منظف') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المنظفين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل منظف @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل منظف @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المنظفين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل منظف (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل منظف (%d+)')
DevHid:srem(Twix..'Hid:Cleaner:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المنظفين")  
end end
--     Source Twix     --
--       Set admin        --
if Manager(msg) then
if text ==('رفع ادمن') and ChCheck(msg) then
function prom_reply(extra, result, success)
if not BasicConstructor(msg) and DevHid:get(Twix.."Hid:Lock:ProSet"..msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة الادمنيه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع ادمن @(.*)') and ChCheck(msg) then
local username = text:match('^رفع ادمن @(.*)')
function promreply(extra,result,success)
if not BasicConstructor(msg) and DevHid:get(Twix.."Hid:Lock:ProSet"..msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
if result.id_ then
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة الادمنيه")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع ادمن (%d+)') and ChCheck(msg) then
local user = text:match('رفع ادمن (%d+)')
if not BasicConstructor(msg) and DevHid:get(Twix.."Hid:Lock:ProSet"..msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة الادمنيه")  
end
--     Source Twix     --
--        Rem admin       --
if text ==('تنزيل ادمن') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة الادمنيه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل ادمن @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل ادمن @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة الادمنيه")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل ادمن (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل ادمن (%d+)')
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة الادمنيه")  
end end
--     Source Twix     --
--       Set Vipmem       --
if Admin(msg) then
if text ==('رفع مميز') and ChCheck(msg) then
function prom_reply(extra, result, success)
if not BasicConstructor(msg) and DevHid:get(Twix.."Hid:Lock:ProSet"..msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevHid:sadd(Twix..'Hid:VipMem:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المميزين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^رفع مميز @(.*)') and ChCheck(msg) then
local username = text:match('^رفع مميز @(.*)')
function promreply(extra,result,success)
if not BasicConstructor(msg) and DevHid:get(Twix.."Hid:Lock:ProSet"..msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
if result.id_ then
DevHid:sadd(Twix..'Hid:VipMem:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفعه في قائمة المميزين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^رفع مميز (%d+)') and ChCheck(msg) then
local user = text:match('رفع مميز (%d+)')
if not BasicConstructor(msg) and DevHid:get(Twix.."Hid:Lock:ProSet"..msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لاتستطيع رفع احد وذالك بسبب تعطيل الرفع من قبل المنشئيين', 1, 'md')
return false
end
DevHid:sadd(Twix..'Hid:VipMem:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفعه في قائمة المميزين")  
end
--     Source Twix     --
--       Rem Vipmem       --
if text ==('تنزيل مميز') and ChCheck(msg) then
function prom_reply(extra, result, success)
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_,result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المميزين")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end end
if text and text:match('^تنزيل مميز @(.*)') and ChCheck(msg) then
local username = text:match('^تنزيل مميز @(.*)')
function promreply(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_,result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تنزيله من قائمة المميزين")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,promreply)
end
if text and text:match('^تنزيل مميز (%d+)') and ChCheck(msg) then
local user = text:match('تنزيل مميز (%d+)')
DevHid:srem(Twix..'Hid:VipMem:'..msg.chat_id_,user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تنزيله من قائمة المميزين")  
end end 
--     Source Twix     --
if BasicConstructor(msg) then
if text and text:match("^رفع مشرف$") and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..Twix)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=True&can_delete_messages=True&can_invite_users=True&can_restrict_members=True&can_pin_messages=True&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه مشرف في المجموعه")  
else
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and text:match("^تنزيل مشرف$") and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..Twix)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من مشرفين المجموعه")  
else
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end 
if text and (text:match("^رفع بكل الصلاحيات$") or text:match("^رفع بكل صلاحيات$")) and msg.reply_to_message_id_ then
function promote_by_reply(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..Twix)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=True&can_delete_messages=True&can_invite_users=True&can_restrict_members=True&can_pin_messages=True&can_promote_members=True")
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه مشرف في جميع الصلاحيات")  
else
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
if text and (text:match("^وضع لقب (.*)$") or text:match("^رفع مشرف (.*)$") or text:match("^ضع لقب (.*)$")) and ChCheck(msg) then
local Hid = text:match("^وضع لقب (.*)$") or text:match("^رفع مشرف (.*)$") or text:match("^ضع لقب (.*)$")
function ReplySet(extra, result, success)
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..Twix)
local GetInfo = JSON.decode(Check)
if GetInfo.result.can_promote_members == true then 
https.request("https://api.telegram.org/bot"..TokenBot.."/promoteChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&can_change_info=false&can_delete_messages=false&can_invite_users=True&can_restrict_members=false&can_pin_messages=True&can_promote_members=false")
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم اضافة 𓄂 "..Hid.." كلقب له")  
https.request("https://api.telegram.org/bot"..TokenBot.."/setChatAdministratorCustomTitle?chat_id=" .. msg.chat_id_ .. "&user_id=" ..result.sender_user_id_.."&custom_title="..Hid)
else
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ ليست لدي صلاحية اضافة مشرفين جدد يرجى التحقق من الصلاحيات', 1, 'md')
end
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ReplySet)
end
end
end
--     Source Twix     --
if text == "صلاحيتي" or text == "صلاحياتي" and ChCheck(msg) then 
if tonumber(msg.reply_to_message_id_) == 0 then 
Validity(msg,msg.sender_user_id_)
end end
if text ==('صلاحيته') or text ==('صلاحياته') and ChCheck(msg) then
function ValidityReply(extra, result, success)
Validity(msg,result.sender_user_id_)
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ValidityReply)
end end
if text and (text:match('^صلاحيته @(.*)') or text:match('^صلاحياته @(.*)')) and ChCheck(msg) then
local username = text:match('^صلاحيته @(.*)') or text:match('^صلاحياته @(.*)')
function ValidityUser(extra,result,success)
if result.id_ then
Validity(msg,result.id_) 
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,ValidityUser)
end
if text and (text:match('^صلاحيته (%d+)') or text:match('^صلاحياته (%d+)')) and ChCheck(msg) then
local ValidityId = text:match('صلاحيته (%d+)') or text:match('صلاحياته (%d+)')
Validity(msg,ValidityId)  
end
--     Source Twix     --
if Admin(msg) then
if msg.reply_to_message_id_ ~= 0 then
if text and (text:match("^مسح$") or text:match("^حذف$")) and ChCheck(msg) then
DeleteMessage(msg.chat_id_,{[0] = msg.reply_to_message_id_})
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حذف الرساله مع رسالة الامر', 1, 'md')
end end end
--     Source Twix     --
if Constructor(msg) then
if text == "تفعيل الحظر" and ChCheck(msg) or text == "تفعيل الطرد" and ChCheck(msg) then
DevHid:del(Twix.."Hid:Lock:KickBan"..msg.chat_id_)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الطرد والحظر'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تعطيل الحظر" and ChCheck(msg) or text == "تعطيل الطرد" and ChCheck(msg) then
DevHid:set(Twix.."Hid:Lock:KickBan"..msg.chat_id_,"true")
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الطرد والحظر'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تفعيل الكتم" and ChCheck(msg) or text == "تفعيل التقييد" and ChCheck(msg) then
DevHid:del(Twix.."Hid:Lock:MuteTked"..msg.chat_id_)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الكتم والتقيد'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
if text == "تعطيل الكتم" and ChCheck(msg) or text == "تعطيل التقييد" and ChCheck(msg) then
DevHid:set(Twix.."Hid:Lock:MuteTked"..msg.chat_id_,"true")
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الكتم والتقيد'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
end
if BasicConstructor(msg) then
if text == "تفعيل الرفع" and ChCheck(msg) or text == "تفعيل الترقيه" and ChCheck(msg) then
DevHid:del(Twix.."Hid:Lock:ProSet"..msg.chat_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تفعيل رفع 𓄂 الادمن • المميز', 1, 'md')
end
if text == "تعطيل الرفع" and ChCheck(msg) or text == "تعطيل الترقيه" and ChCheck(msg) then
DevHid:set(Twix.."Hid:Lock:ProSet"..msg.chat_id_,"true")
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تعطيل رفع 𓄂 الادمن • المميز', 1, 'md')
end
end
--     Source Twix     --
--          Kick          --
if Admin(msg) then
if text ==('طرد') and ChCheck(msg) then
function KickReply(extra, result, success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع طرد 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⸙ ¦ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⸙ ¦ لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(result.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم طرده من المجموعه")  
end,nil)
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),KickReply)
end end
if text and text:match('^طرد @(.*)') and ChCheck(msg) then
local username = text:match('^طرد @(.*)')
function KickUser(extra,result,success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع طرد 𓄂 '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⸙ ¦ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⸙ ¦ لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم طرده من المجموعه")  
end,nil)
end
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,KickUser)
end
if text and text:match('^طرد (%d+)') and ChCheck(msg) then
local user = text:match('طرد (%d+)')
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع طرد 𓄂 '..IdRank(user, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=user,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⸙ ¦ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⸙ ¦ لا استطيع طرد مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم طرده من المجموعه")  
end,nil)
end
end
end 
--     Source Twix     --
--          Ban           --
if Admin(msg) then
if text ==('حضر') or text ==('حظر') and ChCheck(msg) then
function BanReply(extra, result, success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع حظر 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⸙ ¦ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⸙ ¦ لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(result.chat_id_, result.sender_user_id_)
DevHid:sadd(Twix..'Hid:Ban:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم حظره من المجموعه") 
end,nil) 
end 
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),BanReply)
end end
if text and (text:match('^حضر @(.*)') or text:match('^حظر @(.*)')) and ChCheck(msg) then
local username = text:match('^حضر @(.*)') or text:match('^حظر @(.*)')
function BanUser(extra,result,success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع حظر 𓄂 '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=result.id_,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⸙ ¦ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⸙ ¦ لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, result.id_)
DevHid:sadd(Twix..'Hid:Ban:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم حظره من المجموعه")  
end,nil) 
end
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,BanUser)
end
if text and (text:match('^حضر (%d+)') or text:match('^حظر (%d+)')) and ChCheck(msg) then
local user = text:match('حضر (%d+)') or text:match('حظر (%d+)')
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:KickBan"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الطرد والحظر من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع حظر 𓄂 '..IdRank(user, msg.chat_id_), 1, 'md')
else
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=user,status_={ID="ChatMemberStatusKicked"},},function(arg,dp) 
if (dp and dp.code_ and dp.code_ == 400 and dp.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_,msg.id_,"⸙ ¦ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if dp and dp.code_ and dp.code_ == 400 and dp.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_,msg.id_,"⸙ ¦ لا استطيع حظر مشرفين المجموعه") 
return false  
end
ChatKick(msg.chat_id_, user)
DevHid:sadd(Twix..'Hid:Ban:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم حظره من المجموعه")  
end,nil) 
end
end
--     Source Twix     --
--         UnBan          --
if text ==('الغاء الحظر') or text ==('الغاء حظر') and ChCheck(msg) then
function UnBanReply(extra, result, success)
DevHid:srem(Twix..'Hid:Ban:'..msg.chat_id_, result.sender_user_id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.sender_user_id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم الغاء حظره من المجموعه")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnBanReply)
end end
if text and (text:match('^الغاء الحظر @(.*)') or text:match('^الغاء حظر @(.*)')) and ChCheck(msg) then
local username = text:match('^الغاء الحظر @(.*)') or text:match('^الغاء حظر @(.*)')
function UnBanUser(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:Ban:'..msg.chat_id_, result.id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم الغاء حظره من المجموعه")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnBanUser)
end
if text and (text:match('^الغاء الحظر (%d+)') or text:match('^الغاء حظر (%d+)')) and ChCheck(msg) then
local user = text:match('الغاء الحظر (%d+)') or text:match('الغاء حظر (%d+)')
DevHid:srem(Twix..'Hid:Ban:'..msg.chat_id_, user)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = user, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
ReplyStatus(msg,user,"Reply","⸙ ¦ تم الغاء حظره من المجموعه")  
end 
end 
--     Source Twix     --
--          Mute          --
if Admin(msg) then
if text ==('كتم') and ChCheck(msg) then
function MuteReply(extra, result, success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع كتم 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
if DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ هو بالفعل مكتوم من المجموعه")  
else
DevHid:sadd(Twix..'Hid:Muted:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم كتمه من المجموعه")  
end 
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MuteReply)
end end
if text and text:match('^كتم @(.*)') and ChCheck(msg) then
local username = text:match('^كتم @(.*)')
function MuteUser(extra,result,success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع كتم 𓄂 '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
if DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_, result.id_) then
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ هو بالفعل مكتوم من المجموعه")  
else
DevHid:sadd(Twix..'Hid:Muted:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم كتمه من المجموعه")  
end
end
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,MuteUser)
end
if text and text:match('^كتم (%d+)') and ChCheck(msg) then
local user = text:match('كتم (%d+)')
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع كتم 𓄂 '..IdRank(user, msg.chat_id_), 1, 'md')
else
if DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_, user) then
ReplyStatus(msg,user,"Reply","⸙ ¦ هو بالفعل مكتوم من المجموعه")  
else
DevHid:sadd(Twix..'Hid:Muted:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم كتمه من المجموعه")  
end
end
end
--     Source Twix     --
--         UnMute         --
if text ==('الغاء الكتم') or text ==('الغاء كتم') and ChCheck(msg) then
function UnMuteReply(extra, result, success)
if not DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ هو ليس مكتوم لالغاء كتمه")  
else
DevHid:srem(Twix..'Hid:Muted:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم الغاء كتمه من المجموعه")  
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnMuteReply)
end end
if text and (text:match('^الغاء الكتم @(.*)') or text:match('^الغاء كتم @(.*)')) and ChCheck(msg) then
local username = text:match('^الغاء الكتم @(.*)') or text:match('^الغاء كتم @(.*)')
function UnMuteUser(extra,result,success)
if result.id_ then
if not DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_, result.id_) then
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ هو ليس مكتوم لالغاء كتمه")  
else
DevHid:srem(Twix..'Hid:Muted:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم الغاء كتمه من المجموعه")  
end
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnMuteUser)
end
if text and (text:match('^الغاء الكتم (%d+)') or text:match('^الغاء كتم (%d+)')) and ChCheck(msg) then
local user = text:match('الغاء الكتم (%d+)') or text:match('الغاء كتم (%d+)')
if not DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_, user) then
ReplyStatus(msg,user,"Reply","⸙ ¦ هو ليس مكتوم لالغاء كتمه")  
else
DevHid:srem(Twix..'Hid:Muted:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم الغاء كتمه من المجموعه")  
end
end 
end 
--     Source Twix     --
--          Tkeed           --
if Admin(msg) then
if text ==('تقييد') or text ==('تقيد') and ChCheck(msg) then
function TkeedReply(extra, result, success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(result.sender_user_id_, result.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع تقيد 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_)
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تقيده من المجموعه")  
end
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),TkeedReply)
end end
if text and (text:match('^تقييد @(.*)') or text:match('^تقيد @(.*)')) and ChCheck(msg) then
local username = text:match('^تقييد @(.*)') or text:match('^تقيد @(.*)')
function TkeedUser(extra,result,success)
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if result.id_ then
if RankChecking(result.id_, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع تقيد 𓄂 '..IdRank(result.id_, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_)
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم تقيده من المجموعه")  
end
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,TkeedUser)
end
if text and (text:match('^تقييد (%d+)') or text:match('^تقيد (%d+)')) and ChCheck(msg) then
local user = text:match('تقييد (%d+)') or text:match('تقيد (%d+)')
if not Constructor(msg) and DevHid:get(Twix.."Hid:Lock:MuteTked"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ لقد تم تعطيل الكتم والتقيد من قبل المنشئين')
return false
end
if RankChecking(user, msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع تقيد 𓄂 '..IdRank(user, msg.chat_id_), 1, 'md')
else
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..user)
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم تقيده من المجموعه")  
end
end
--     Source Twix     --
--         UnTkeed          --
if text ==('الغاء تقييد') or text ==('الغاء تقيد') and ChCheck(msg) then
function UnTkeedReply(extra, result, success)
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevHid:srem(Twix..'Hid:Tkeed:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم الغاء تقيده من المجموعه")  
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnTkeedReply)
end end
if text and (text:match('^الغاء تقييد @(.*)') or text:match('^الغاء تقيد @(.*)')) and ChCheck(msg) then
local username = text:match('^الغاء تقييد @(.*)') or text:match('^الغاء تقيد @(.*)')
function UnTkeedUser(extra,result,success)
if result.id_ then
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevHid:srem(Twix..'Hid:Tkeed:'..msg.chat_id_, result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم الغاء تقيده من المجموعه")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnTkeedUser)
end
if text and (text:match('^الغاء تقييد (%d+)') or text:match('^الغاء تقيد (%d+)')) and ChCheck(msg) then
local user = text:match('الغاء تقييد (%d+)') or text:match('الغاء تقيد (%d+)')
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..user.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
DevHid:srem(Twix..'Hid:Tkeed:'..msg.chat_id_, user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم الغاء تقيده من المجموعه")  
end
end 
end
--     Source Twix     --
--         BanAll         --
if SecondSudo(msg) then
if text ==('حضر عام') or text ==('حظر عام') then
function BanAllReply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(result.sender_user_id_) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',result.sender_user_id_) and not Sudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
ChatKick(result.chat_id_, result.sender_user_id_)
DevHid:sadd(Twix..'Hid:BanAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم حظره عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),BanAllReply)
end end
if text and (text:match('^حضر عام @(.*)') or text:match('^حظر عام @(.*)')) then
local username = text:match('^حضر عام @(.*)') or text:match('^حظر عام @(.*)')
function BanAllUser(extra,result,success)
if tonumber(result.id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(result.id_) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',result.id_) and not Sudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
if result.id_ then
ChatKick(msg.chat_id_, result.id_)
DevHid:sadd(Twix..'Hid:BanAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم حظره عام من المجموعات")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,BanAllUser)
end
if text and (text:match('^حضر عام (%d+)') or text:match('^حظر عام (%d+)')) then
local user = text:match('حضر عام (%d+)') or text:match('حظر عام (%d+)')
if tonumber(user) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر البوت عام*", 1, 'md')
return false 
end
if SudoId(tonumber(user)) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر المطور الاساسي*", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',user) and not Sudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع حظر المطور الثانوي*", 1, 'md')
return false 
end
ChatKick(msg.chat_id_, user)
DevHid:sadd(Twix..'Hid:BanAll:', user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم حظره عام من المجموعات")  
end
--     Source Twix     --
--         MuteAll        --
if text ==('كتم عام') then
function MuteAllReply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(result.sender_user_id_) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',result.sender_user_id_) and not Sudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
DevHid:sadd(Twix..'Hid:MuteAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم كتمه عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MuteAllReply)
end end
if text and text:match('^كتم عام @(.*)') then
local username = text:match('^كتم عام @(.*)')
function MuteAllUser(extra,result,success)
if tonumber(result.id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(result.id_) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',result.id_) and not Sudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
if result.id_ then
DevHid:sadd(Twix..'Hid:MuteAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم كتمه عام من المجموعات")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,MuteAllUser)
end
if text and text:match('^كتم عام (%d+)') then
local user = text:match('كتم عام (%d+)')
if tonumber(user) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم البوت عام*", 1, 'md')
return false 
end
if SudoId(tonumber(user)) == true then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم المطور الاساسي*", 1, 'md')
return false 
end
if DevHid:sismember(Twix..'Hid:SecondSudo:',user) and not Sudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتستطيع كتم المطور الثانوي*", 1, 'md')
return false 
end
DevHid:sadd(Twix..'Hid:MuteAll:', user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم كتمه عام من المجموعات")  
end
--     Source Twix     --
--         UnAll          --
if text ==('الغاء عام') or text ==('الغاء العام') then
function UnAllReply(extra, result, success)
DevHid:srem(Twix..'Hid:BanAll:', result.sender_user_id_)
DevHid:srem(Twix..'Hid:MuteAll:', result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم الغاء (الحظر • الكتم) عام من المجموعات")  
end 
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),UnAllReply)
end end
if text and (text:match('^الغاء عام @(.*)') or text:match('^الغاء العام @(.*)')) then
local username = text:match('^الغاء عام @(.*)') or text:match('^الغاء العام @(.*)')
function UnAllUser(extra,result,success)
if result.id_ then
DevHid:srem(Twix..'Hid:BanAll:', result.id_)
DevHid:srem(Twix..'Hid:MuteAll:', result.id_)
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم الغاء (الحظر • الكتم) عام من المجموعات")  
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')
end end 
resolve_username(username,UnAllUser)
end
if text and (text:match('^الغاء عام (%d+)') or text:match('^الغاء العام (%d+)')) then
local user = text:match('الغاء عام (%d+)') or text:match('الغاء العام (%d+)')
DevHid:srem(Twix..'Hid:BanAll:', user)
DevHid:srem(Twix..'Hid:MuteAll:', user)
ReplyStatus(msg,user,"Reply","⸙ ¦ تم الغاء (الحظر • الكتم) عام من المجموعات")  
end
end
end
--     Source Twix     --
if (text == "تغير المطور الاساسي" or text == "نقل ملكيه البوت" or text == "تغيير المطور الاساسي" or text == "𓄂 تغير المطور الاساسي ⸙") and msg.reply_to_message_id_ == 0 and Sudo(msg) then 
send(msg.chat_id_, msg.id_,'⸙ ¦ يجب التاكد ان المطور الجديد ارسل start لخاص البوت بعد ذلك يمكنك ارسال ايدي المطور')
DevHid:setex(Twix.."Hid:EditDev"..msg.sender_user_id_,300,true)
end
if DevHid:get(Twix.."Hid:EditDev"..msg.sender_user_id_) then
if text and text:match("^الغاء$") then 
send(msg.chat_id_, msg.id_,'⸙ ¦ تم الغاء امر تغير المطور الاساسي')
DevHid:del(Twix.."Hid:EditDev"..msg.sender_user_id_)
return false
end
if text and text:match("^(%d+)$") then 
tdcli_function ({ID = "GetUser",user_id_ = text},function(arg,dp) 
if dp.first_name_ ~= false then
DevHid:del(Twix.."Hid:EditDev"..msg.sender_user_id_)
DevHid:set(Twix.."Hid:NewDev"..msg.sender_user_id_,dp.id_)
if dp.username_ ~= false then DevUser = '\n⸙ ¦ المعرف 𓄂 [@'..dp.username_..']' else DevUser = '' end
local Text = '⸙ ¦ الايدي 𓄂 '..dp.id_..DevUser..'\n⸙ ¦ الاسم 𓄂 ['..dp.first_name_..'](tg://user?id='..dp.id_..')\n⸙ ¦ تم حفظ المعلومات بنجاح\n⸙ ¦ استخدم الازرار للتاكيد 𓄂 ⤈'
keyboard = {} 
keyboard.inline_keyboard = {{{text="نعم",callback_data="/setyes"},{text="لا",callback_data="/setno"}}} 
Msg_id = msg.id_/2097152/0.5
return https.request("https://api.telegram.org/bot"..TokenBot..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(Text).."&reply_to_message_id="..Msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
send(msg.chat_id_, msg.id_,"⸙ ¦ المعلومات خاطئه قم بالتاكد واعد المحاوله")
DevHid:del(Twix.."Hid:EditDev"..msg.sender_user_id_)
end
end,nil)
return false
end
end
--     Source Twix     --
if msg.reply_to_message_id_ ~= 0 then
if text and text:match("^رفع مطي$") and not DevHid:get(Twix..'Hid:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
if DevHid:sismember(Twix..'User:Donky:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ هو مطي شرفع منه بعد😹💔") 
else
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفعه في قائمة المطايه") 
DevHid:sadd(Twix..'User:Donky:'..msg.chat_id_, result.sender_user_id_)
end end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source Twix     --
if msg.reply_to_message_id_ ~= 0  then
if text and text:match("^تنزيل مطي$") and not DevHid:get(Twix..'Hid:Lock:Stupid'..msg.chat_id_) and ChCheck(msg) then
function donky_by_reply(extra, result, success)
if not DevHid:sismember(Twix..'User:Donky:'..msg.chat_id_, result.sender_user_id_) then
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ هو ليس مطي ليتم تنزيله") 
else
DevHid:srem(Twix..'User:Donky:'..msg.chat_id_, result.sender_user_id_)
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تنزيله من قائمة المطايه") 
end end
getMessage(msg.chat_id_, msg.reply_to_message_id_,donky_by_reply)
end end
--     Source Twix     --
if Admin(msg) then
if text and (text:match('^تقييد دقيقه (%d+)$') or text:match('^كتم دقيقه (%d+)$') or text:match('^تقيد دقيقه (%d+)$')) and ChCheck(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد دقيقه (%d+)$') or text:match('^كتم دقيقه (%d+)$') or text:match('^تقيد دقيقه (%d+)$')
local Minutes = string.gsub(mutept, 'm', '')
local num1 = tonumber(Minutes) * 60 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع تقيد 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تقيده لمدة 𓄂 "..mutept.." د") 
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end 
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end
if text and (text:match('^تقييد ساعه (%d+)$') or text:match('^كتم ساعه (%d+)$') or text:match('^تقيد ساعه (%d+)$')) and ChCheck(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد ساعه (%d+)$') or text:match('^كتم ساعه (%d+)$') or text:match('^تقيد ساعه (%d+)$')
local hour = string.gsub(mutept, 'h', '')
local num1 = tonumber(hour) * 3600 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع تقيد 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تقيده لمدة 𓄂 "..mutept.." س") 
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end 
if text and (text:match('^تقييد يوم (%d+)$') or text:match('^كتم يوم (%d+)$') or text:match('^تقيد يوم (%d+)$')) and ChCheck(msg) then 
local function mut_time(extra, result,success)
local mutept = text:match('^تقييد يوم (%d+)$') or text:match('^كتم يوم (%d+)$') or text:match('^تقيد يوم (%d+)$')
local day = string.gsub(mutept, 'd', '')
local num1 = tonumber(day) * 86400 
if RankChecking(result.sender_user_id_, msg.chat_id_) then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا تستطيع تقيد 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_), 1, 'md') 
else 
https.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+num1))
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم تقيده لمدة 𓄂 "..mutept.." ي") 
DevHid:sadd(Twix..'Hid:Tkeed:'..msg.chat_id_, result.sender_user_id_)
end end
if tonumber(msg.reply_to_message_id_) == 0 then else
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, mut_time,nil) end 
end 
end 
--     Source Twix     --
if text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ == 0 and ChCheck(msg) then  
if Constructor(msg) then
TXT = text:match("^اضف رسائل (%d+)$")
DevHid:set('HidTwixTEAM:'..Twix..'id:user'..msg.chat_id_,TXT)  
DevHid:setex('HidTwixTEAM:'..Twix.."numadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل عدد الرسائل الان \n⸙ ¦ ارسل الغاء لالغاء الامر ", 1, "md")
Dev_Hid(msg.chat_id_, msg.id_, 1,numd, 1, 'md') 
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر للمنشئين فقط', 1, 'md') 
end 
end 
if text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
local Num = text:match("^اضف رسائل (%d+)$")
function Reply(extra, result, success)
DevHid:del(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..result.sender_user_id_) 
DevHid:incrby(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..result.sender_user_id_,Num) 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اضافة "..Num..' رساله', 1, 'md') 
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},Reply, nil)
return false
end
if text and text:match("^اضف نقاط (%d+)$") and msg.reply_to_message_id_ == 0 and ChCheck(msg) then  
if Constructor(msg) then
TXT = text:match("^اضف نقاط (%d+)$")
DevHid:set('HidTwixTEAM:'..Twix..'ids:user'..msg.chat_id_,TXT)  
DevHid:setex('HidTwixTEAM:'..Twix.."nmadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل عدد النقاط الان \n⸙ ¦ ارسل الغاء لالغاء الامر ", 1, "md")
Dev_Hid(msg.chat_id_, msg.id_, 1,numd, 1, 'md') 
else 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر للمنشئين فقط', 1, 'md') 
end 
end 
if text and text:match("^اضف نقاط (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
local Num = text:match("^اضف نقاط (%d+)$")
function Reply(extra, result, success)
DevHid:incrby(Twix..'Hid:GamesNumber'..msg.chat_id_..result.sender_user_id_,Num) 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اضافة "..Num..' نقطه', 1, 'md') 
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},Reply, nil)
return false
end
if DevHid:get(Twix..'Hid:Lock:Clean'..msg.chat_id_) then if msg.content_.video_ or msg.content_.document_ or msg.content_.sticker_ or msg.content_.photo_ or msg.content_.animation_ then if msg.reply_to_message_id_ ~= 0 then DevHid:sadd(Twix.."Hid:cleaner"..msg.chat_id_, msg.id_) else DevHid:sadd(Twix.."Hid:cleaner"..msg.chat_id_, msg.id_) end end end
if Manager(msg) and msg.reply_to_message_id_ ~= 0 then
if text and text:match("^تثبيت$") and ChCheck(msg) then 
if DevHid:sismember(Twix.."Hid:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Hid(msg.chat_id_,msg.id_, 1, "⸙ ¦ التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100",""),message_id_ = msg.reply_to_message_id_,disable_notification_ = 1},function(arg,data) 
if data.ID == "Ok" then
DevHid:set(Twix..'Hid:PinnedMsg'..msg.chat_id_,msg.reply_to_message_id_)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تثبيت الرساله بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
return false  
end
if data.code_ == 6 then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ البوت ليس ادمن هنا !', 1, 'md')
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات', 1, 'md')
return false  
end
end,nil)
end 
end
--     Source Twix     --
if Admin(msg) then
if text == "المميزين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:VipMem:'..msg.chat_id_)
text = "⸙ ¦ قائمة المميزين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد مميزين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 
--     Source Twix     --
if Manager(msg) then
if text == "الادمنيه" and ChCheck(msg) or text == "الادمنية" and ChCheck(msg) then 
local Hid =  'Hid:Admins:'..msg.chat_id_
local List = DevHid:smembers(Twix..Hid)
text = "⸙ ¦ قائمة الادمنيه 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⸙ ¦ *لا يوجد ادمنيه*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end
--     Source Twix     -- 
if Constructor(msg) then
if text == "المدراء" and ChCheck(msg) or text == "مدراء" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:Managers:'..msg.chat_id_)
text = "⸙ ¦ قائمة المدراء 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد مدراء*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "المنظفين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:Cleaner:'..msg.chat_id_)
text = "⸙ ¦ قائمة المنظفين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد منظفين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 
--     Source Twix     --
if BasicConstructor(msg) then
if text == "المنشئين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:Constructor:'..msg.chat_id_)
text = "⸙ ¦ قائمة المنشئين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد منشئين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end end 
--     Source Twix     --
if HidConstructor(msg) then
if text == "المنشئين الاساسيين" and ChCheck(msg) or text == "منشئين اساسيين" and ChCheck(msg) or text == "المنشئين الاساسين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:BasicConstructor:'..msg.chat_id_)
text = "⸙ ¦ قائمة المنشئين الاساسيين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد منشئين اساسيين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
end 
if text ==("المنشئ") and ChCheck(msg) or text ==("المالك") and ChCheck(msg) then
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,dp) 
if dp.first_name_ == false then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ حساب المنشئ محذوف", 1, "md")
return false  
end
local UserName = (dp.username_ or "x_xxax")
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ منشئ المجموعه 𓄂 ["..dp.first_name_.."](T.me/"..UserName..")", 1, "md")  
end,nil)   
end
end
end,nil)   
end
--     Source Twix     --
if Admin(msg) then
if text == "المكتومين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:Muted:'..msg.chat_id_)
text = "⸙ ¦ قائمة المكتومين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد مكتومين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
--     Source Twix     --
if text == "المقيدين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:Tkeed:'..msg.chat_id_)
text = "⸙ ¦ قائمة المقيدين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⸙ ¦ *لا يوجد مقيدين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
--     Source Twix     --
if text == "المحظورين" and ChCheck(msg) or text == "المحضورين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:Ban:'..msg.chat_id_)
text = "⸙ ¦ قائمة المحظورين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد محظورين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
if text == "قائمه المنع" and ChCheck(msg) then
local List = DevHid:hkeys(Twix..'Hid:Filters:'..msg.chat_id_)
text = "⸙ ¦ قائمة المنع 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k, v in pairs(List) do
text = text..k..'~ ❨ '..v..' ❩\n'
end
if #List == 0 then
text = "⸙ ¦ لا توجد كلمات ممنوعه"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end 
--     Source Twix     --
if text == "المطايه" and ChCheck(msg) or text == "المطاية" and ChCheck(msg) then
local List = DevHid:smembers(Twix..'User:Donky:'..msg.chat_id_)
text = "⸙ ¦ قائمة مطاية المجموعه 😹💔 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⸙ ¦ *لا يوجد مطايه كلها اوادم* 😹💔"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
--     Source Twix     --
if text == "المطورين الثانويين" and SecondSudo(msg) or text == "الثانويين" and SecondSudo(msg) then 
local List = DevHid:smembers(Twix..'Hid:SecondSudo:')
text = "⸙ ¦ قائمة المطورين الثانويين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⸙ ¦ *عذرا لم يتم رفع اي مطورين ثانويين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
--     Source Twix     --
if SudoBot(msg) then
if text == "قائمه العام" and ChCheck(msg) or text == "المحظورين عام" and ChCheck(msg) or text == "المكتومين عام" and ChCheck(msg) or text == "𓄂 قائمه العام ⸙" and ChCheck(msg) then 
local BanAll = DevHid:smembers(Twix..'Hid:BanAll:')
local MuteAll = DevHid:smembers(Twix..'Hid:MuteAll:')
if #BanAll ~= 0 then 
text = "⸙ ¦ قائمة المحظورين عام 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(BanAll) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
else
text = ""
end
if #MuteAll ~= 0 then 
text = text.."⸙ ¦ قائمة المكتومين عام 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(MuteAll) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
else
text = text
end
if #BanAll ~= 0 or #MuteAll ~= 0 then 
text = text
else
text = "⸙ ¦ *لم يتم حظر او كتم اي عضو*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
--     Source Twix     --
if text == "المطورين" and ChCheck(msg) or text == "𓄂 المطورين ⸙" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:SudoBot:')
text = "⸙ ¦ قائمة المطورين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local sudouser = DevHid:get(Twix..'Hid:Sudos'..v) 
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."] ↬ Gps : "..(sudouser or 0).."\n"
else
text = text..""..k.."~ : `"..v.."` ↬ Gps : "..(sudouser or 0).."\n"
end end
if #List == 0 then
text = "⸙ ¦ *عذرا لم يتم رفع اي مطورين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
--     Source Twix     --
if text == "المدراء العامين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:ManagerAll:')
text = "⸙ ¦ قائمة المدراء العامين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد مدراء عامين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end
--     Source Twix     --
if text == "المميزين عام" and ChCheck(msg) or text == "المميزين العامين" and ChCheck(msg) then 
local List = DevHid:smembers(Twix..'Hid:VipAll:')
text = "⸙ ¦ قائمة المميزين العام 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then 
text = "⸙ ¦ *لا يوجد مميزين عام*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end 
--     Source Twix     -- 
if text == "الادمنيه العامين" and ChCheck(msg) then 
local Hid =  'Hid:AdminAll:'
local List = DevHid:smembers(Twix..Hid)
text = "⸙ ¦ قائمة الادمنيه العامين 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local username = DevHid:get(Twix..'Save:UserName'..v)
if username then
text = text..""..k.."~ : [@"..username.."]\n"
else
text = text..""..k.."~ : `"..v.."`\n"
end end
if #List == 0 then
text = "⸙ ¦ *لا يوجد ادمنيه عامين*"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, text, 1, "md")
end  
--     Source Twix     --
if text ==("رفع المنشئ") and ChCheck(msg) or text ==("رفع المالك") and ChCheck(msg) then 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
DevHid:del(Twix..'Hid:HidConstructor:'..msg.chat_id_)
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
end
end
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,dp) 
if dp.first_name_ == false then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ حساب المنشئ محذوف", 1, "md")
return false  
end
local UserName = (dp.username_ or "x_xxax")
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم رفع منشئ المجموعه 𓄂 ["..dp.first_name_.."](T.me/"..UserName..")", 1, "md") 
DevHid:sadd(Twix.."Hid:HidConstructor:"..msg.chat_id_,dp.id_)
end,nil)   
end,nil)   
end
end 
--     Source Twix     --
if Manager(msg) then
if text == 'منع' and tonumber(msg.reply_to_message_id_) > 0 and ChCheck(msg) then 
function filter_by_reply(extra, result, success) 
if result.content_.sticker_ then
local idsticker = result.content_.sticker_.sticker_.persistent_id_
DevHid:sadd(Twix.."Hid:FilterSteckr"..msg.chat_id_,idsticker)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم منع الملصق بنجاح لن يتم ارساله مجددا', 1, 'md')
return false
end
if result.content_.ID == "MessagePhoto" then
local photo = result.content_.photo_.id_
DevHid:sadd(Twix.."Hid:FilterPhoto"..msg.chat_id_,photo)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم منع الصوره بنجاح لن يتم ارسالها مجددا', 1, 'md')
return false
end
if result.content_.animation_ then
local idanimation = result.content_.animation_.animation_.persistent_id_
DevHid:sadd(Twix.."Hid:FilterAnimation"..msg.chat_id_,idanimation)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم منع المتحركه بنجاح لن يتم ارسالها مجددا', 1, 'md')
return false
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,filter_by_reply) 
end
--     Source Twix     --
if text == 'الغاء منع' and tonumber(msg.reply_to_message_id_) > 0 and ChCheck(msg) then     
function unfilter_by_reply(extra, result, success) 
if result.content_.sticker_ then
local idsticker = result.content_.sticker_.sticker_.persistent_id_
DevHid:srem(Twix.."Hid:FilterSteckr"..msg.chat_id_,idsticker)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء منع الملصق يمكنهم ارساله الان', 1, 'md')
return false
end
if result.content_.ID == "MessagePhoto" then
local photo = result.content_.photo_.id_
DevHid:srem(Twix.."Hid:FilterPhoto"..msg.chat_id_,photo)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء منع الصوره يمكنهم ارسالها الان', 1, 'md')
return false
end
if result.content_.animation_.animation_ then
local idanimation = result.content_.animation_.animation_.persistent_id_
DevHid:srem(Twix.."Hid:FilterAnimation"..msg.chat_id_,idanimation)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء منع المتحركه يمكنهم ارسالها الان', 1, 'md')
return false
end
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,unfilter_by_reply) 
end
end
--     Source Twix     --
if text and (text == "تفعيل تحويل الصيغ" or text == "تفعيل التحويل") and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل تحويل الصيغ'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Thwel:Hid'..msg.chat_id_) 
end
if text and (text == "تعطيل تحويل الصيغ" or text == "تعطيل التحويل") and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل تحويل الصيغ'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Thwel:Hid'..msg.chat_id_,true)  
end
if text == 'تحويل' and not DevHid:get(Twix..'Hid:Thwel:Hid'..msg.chat_id_) then  
if tonumber(msg.reply_to_message_id_) > 0 then 
function ThwelByReply(extra, result, success)
if result.content_.photo_ then 
local Hid = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.photo_.sizes_[1].photo_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Hid.result.file_path,msg.sender_user_id_..'.png') 
sendSticker(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.png')
os.execute('rm -rf ./'..msg.sender_user_id_..'.png') 
end   
if result.content_.sticker_ then 
local Hid = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.sticker_.sticker_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Hid.result.file_path,msg.sender_user_id_..'.jpg') 
sendPhoto(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.jpg','⸙ ¦ تم تحويل الملصق الى صوره')     
os.execute('rm -rf ./'..msg.sender_user_id_..'.jpg') 
end
if result.content_.audio_ then 
local Hid = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.audio_.audio_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Hid.result.file_path,msg.sender_user_id_..'.ogg') 
sendVoice(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.ogg',"⸙ ¦ تم تحويل الـMp3 الى بصمه")
os.execute('rm -rf ./'..msg.sender_user_id_..'.ogg') 
end   
if result.content_.voice_ then 
local Hid = json:decode(https.request('https://api.telegram.org/bot'.. TokenBot..'/getfile?file_id='..result.content_.voice_.voice_.persistent_id_)) 
download_to_file('https://api.telegram.org/file/bot'..TokenBot..'/'..Hid.result.file_path,msg.sender_user_id_..'.mp3') 
sendAudio(msg.chat_id_, msg.id_, 0, 1,nil, './'..msg.sender_user_id_..'.mp3')  
os.execute('rm -rf ./'..msg.sender_user_id_..'.mp3') 
end
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),ThwelByReply) 
end
end
--     Source Twix     --
if text ==("كشف") and msg.reply_to_message_id_ ~= 0 and ChCheck(msg) or text ==("ايدي") and msg.reply_to_message_id_ ~= 0 and ChCheck(msg) then 
function id_by_reply(extra, result, success) 
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..data.id_) or 0
local user_nkt = tonumber(DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..data.id_) or 0)
if DevHid:sismember(Twix..'Hid:BanAll:',result.sender_user_id_) then
Tkeed = 'محظور عام'
elseif DevHid:sismember(Twix..'Hid:MuteAll:',result.sender_user_id_) then
Tkeed = 'مكتوم عام'
elseif DevHid:sismember(Twix..'Hid:Ban:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'محظور'
elseif DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'مكتوم'
elseif DevHid:sismember(Twix..'Hid:Tkeed:'..msg.chat_id_,result.sender_user_id_) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n⸙ ¦ القيود 𓄂 '..Tkeed
else 
Tked = '' 
end
if DevHid:sismember(Twix..'Hid:SudoBot:',result.sender_user_id_) and SudoBot(msg) then
sudobot = '\n⸙ ¦ عدد الكروبات 𓄂 '..(DevHid:get(Twix..'Hid:Sudos'..result.sender_user_id_) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(result.sender_user_id_,msg.chat_id_) ~= false then
CustomTitle = '\n⸙ ¦ لقبه 𓄂 '..GetCustomTitle(result.sender_user_id_,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ الحساب محذوف', 1, 'md')
return false  end
if data.username_ == false then
Text = '⸙ ¦ اسمه 𓄂 ['..data.first_name_..'](tg://user?id='..result.sender_user_id_..')\n⸙ ¦ ايديه 𓄂 ❨ `'..result.sender_user_id_..'` ❩\n⸙ ¦ رتبته 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_)..''..sudobot..'\n⸙ ¦ رسائله 𓄂 ❨ '..user_msgs..' ❩\n⸙ ¦ تفاعله 𓄂 '..formsgs(user_msgs)..''..CustomTitle..'\n⸙ ¦ نقاطه 𓄂 ❨ '..user_nkt..' ❩'..Tked
SendText(msg.chat_id_,Text,msg.id_/2097152/0.5,'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ معرفه 𓄂 [@'..data.username_..']\n⸙ ¦ ايديه 𓄂 ❨ `'..result.sender_user_id_..'` ❩\n⸙ ¦ رتبته 𓄂 '..IdRank(result.sender_user_id_, msg.chat_id_)..''..sudobot..'\n⸙ ¦ رسائله 𓄂 ❨ '..user_msgs..' ❩\n⸙ ¦ تفاعله 𓄂 '..formsgs(user_msgs)..''..CustomTitle..'\n⸙ ¦ نقاطه 𓄂 ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end
end,nil)
end 
getMessage(msg.chat_id_, msg.reply_to_message_id_,id_by_reply) 
end
if text and text:match('^كشف @(.*)') and ChCheck(msg) or text and text:match('^ايدي @(.*)') and ChCheck(msg) then 
local username = text:match('^كشف @(.*)') or text:match('^ايدي @(.*)')
tdcli_function ({ID = "SearchPublicChat",username_ = username},function(extra, res, success) 
if res and res.message_ and res.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ *المعرف غير صحيح*', 1, 'md')
return false  end
if res.type_.ID == "ChannelChatInfo" then 
if res.type_.channel_.is_supergroup_ == false then
local ch = 'قناة'
local chn = '⸙ ¦ نوع الحساب 𓄂 ❨ '..ch..' ❩\n⸙ ¦ الايدي 𓄂 ❨ `'..res.id_..'` ❩\n⸙ ¦ المعرف 𓄂 ❨ [@'..username..'] ❩\n⸙ ¦ الاسم 𓄂 ❨ ['..res.title_..'] ❩'
Dev_Hid(msg.chat_id_, msg.id_, 1,chn, 1, 'md')
else
local gr = 'مجموعه'
local grr = '⸙ ¦ نوع الحساب 𓄂 ❨ '..gr..' ❩\n⸙ ¦ الايدي 𓄂 ❨ '..res.id_..' ❩\n⸙ ¦ المعرف 𓄂 ❨ [@'..username..'] ❩\n⸙ ¦ الاسم 𓄂 ❨ ['..res.title_..'] ❩'
Dev_Hid(msg.chat_id_, msg.id_, 1,grr, 1, 'md')
end
return false  end
if res.id_ then  
tdcli_function ({ID = "GetUser",user_id_ = res.id_},function(arg,data) 
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..res.id_) or 0
local user_nkt = tonumber(DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..res.id_) or 0)
if DevHid:sismember(Twix..'Hid:BanAll:',res.id_) then
Tkeed = 'محظور عام'
elseif DevHid:sismember(Twix..'Hid:MuteAll:',res.id_) then
Tkeed = 'مكتوم عام'
elseif DevHid:sismember(Twix..'Hid:Ban:'..msg.chat_id_,res.id_) then
Tkeed = 'محظور'
elseif DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_,res.id_) then
Tkeed = 'مكتوم'
elseif DevHid:sismember(Twix..'Hid:Tkeed:'..msg.chat_id_,res.id_) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n⸙ ¦ القيود 𓄂 '..Tkeed
else 
Tked = '' 
end
if DevHid:sismember(Twix..'Hid:SudoBot:',res.id_) and SudoBot(msg) then
sudobot = '\n⸙ ¦ عدد الكروبات 𓄂 '..(DevHid:get(Twix..'Hid:Sudos'..res.id_) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(res.id_,msg.chat_id_) ~= false then
CustomTitle = '\n⸙ ¦ لقبه 𓄂 '..GetCustomTitle(res.id_,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ الحساب محذوف', 1, 'md')
return false  end
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ معرفه 𓄂 [@'..data.username_..']\n⸙ ¦ ايديه 𓄂 ❨ `'..res.id_..'` ❩\n⸙ ¦ رتبته 𓄂 '..IdRank(res.id_, msg.chat_id_)..''..sudobot..'\n⸙ ¦ رسائله 𓄂 ❨ '..user_msgs..' ❩\n⸙ ¦ تفاعله 𓄂 '..formsgs(user_msgs)..''..CustomTitle..'\n⸙ ¦ نقاطه 𓄂 ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end,nil)
end 
end,nil)
return false 
end
if text and text:match('كشف (%d+)') and ChCheck(msg) or text and text:match('ايدي (%d+)') and ChCheck(msg) then 
local iduser = text:match('كشف (%d+)') or text:match('ايدي (%d+)')  
tdcli_function ({ID = "GetUser",user_id_ = iduser},function(arg,data) 
if data.message_ == "User not found" then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ لم يتم التعرف على الحساب', 1, 'md')
return false  
end
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..iduser) or 0
local user_nkt = tonumber(DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..iduser) or 0)
if DevHid:sismember(Twix..'Hid:BanAll:',iduser) then
Tkeed = 'محظور عام'
elseif DevHid:sismember(Twix..'Hid:MuteAll:',iduser) then
Tkeed = 'مكتوم عام'
elseif DevHid:sismember(Twix..'Hid:Ban:'..msg.chat_id_,iduser) then
Tkeed = 'محظور'
elseif DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_,iduser) then
Tkeed = 'مكتوم'
elseif DevHid:sismember(Twix..'Hid:Tkeed:'..msg.chat_id_,iduser) then
Tkeed = 'مقيد'
else
Tkeed = false
end
if Tkeed ~= false then
Tked = '\n⸙ ¦ القيود 𓄂 '..Tkeed
else 
Tked = '' 
end
if DevHid:sismember(Twix..'Hid:SudoBot:',iduser) and SudoBot(msg) then
sudobot = '\n⸙ ¦ عدد الكروبات 𓄂 '..(DevHid:get(Twix..'Hid:Sudos'..iduser) or 0)..'' 
else 
sudobot = '' 
end
if GetCustomTitle(iduser,msg.chat_id_) ~= false then
CustomTitle = '\n⸙ ¦ لقبه 𓄂 '..GetCustomTitle(iduser,msg.chat_id_)
else 
CustomTitle = '' 
end
if data.first_name_ == false then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ الحساب محذوف', 1, 'md')
return false  end
if data.username_ == false then
Text = '⸙ ¦ اسمه 𓄂 ['..data.first_name_..'](tg://user?id='..iduser..')\n⸙ ¦ ايديه 𓄂 ❨ `'..iduser..'` ❩\n⸙ ¦ رتبته 𓄂 '..IdRank(data.id_, msg.chat_id_)..''..sudobot..'\n⸙ ¦ رسائله 𓄂 ❨ '..user_msgs..' ❩\n⸙ ¦ تفاعله 𓄂 '..formsgs(user_msgs)..''..CustomTitle..'\n⸙ ¦ نقاطه 𓄂 ❨ '..user_nkt..' ❩'..Tked
SendText(msg.chat_id_,Text,msg.id_/2097152/0.5,'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ معرفه 𓄂 [@'..data.username_..']\n⸙ ¦ ايديه 𓄂 ❨ `'..iduser..'` ❩\n⸙ ¦ رتبته 𓄂 '..IdRank(data.id_, msg.chat_id_)..''..sudobot..'\n⸙ ¦ رسائله 𓄂 ❨ '..user_msgs..' ❩\n⸙ ¦ تفاعله 𓄂 '..formsgs(user_msgs)..''..CustomTitle..'\n⸙ ¦ نقاطه 𓄂 ❨ '..user_nkt..' ❩'..Tked, 1, 'md')
end
end,nil)
return false 
end 
--     Source Twix     --
if text == 'كشف القيود' and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) and ChCheck(msg) then 
function kshf_by_reply(extra, result, success)
if DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_,result.sender_user_id_) then muted = 'مكتوم' else muted = 'غير مكتوم' end
if DevHid:sismember(Twix..'Hid:Ban:'..msg.chat_id_,result.sender_user_id_) then banned = 'محظور' else banned = 'غير محظور' end
if DevHid:sismember(Twix..'Hid:BanAll:',result.sender_user_id_) then banall = 'محظور عام' else banall = 'غير محظور عام' end
if DevHid:sismember(Twix..'Hid:MuteAll:',result.sender_user_id_) then muteall = 'مكتوم عام' else muteall = 'غير مكتوم عام' end
if DevHid:sismember(Twix..'Hid:Tkeed:',result.sender_user_id_) then tkeed = 'مقيد' else tkeed = 'غير مقيد' end
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الحظر العام 𓄂 '..banall..'\n⸙ ¦ الكتم العام 𓄂 '..muteall..'\n⸙ ¦ الحظر 𓄂 '..banned..'\n⸙ ¦ الكتم 𓄂 '..muted..'\n⸙ ¦ التقيد 𓄂 '..tkeed..'', 1, 'md')  
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),kshf_by_reply) 
end
if text and text:match('^كشف القيود @(.*)') and Admin(msg) and ChCheck(msg) then 
local username = text:match('^كشف القيود @(.*)') 
function kshf_by_username(extra, result, success)
if result.id_ then
if DevHid:sismember(Twix..'Hid:Muted:'..msg.chat_id_,result.id_) then muted = 'مكتوم' else muted = 'غير مكتوم' end
if DevHid:sismember(Twix..'Hid:Ban:'..msg.chat_id_,result.id_) then banned = 'محظور' else banned = 'غير محظور' end
if DevHid:sismember(Twix..'Hid:BanAll:',result.id_) then banall = 'محظور عام' else banall = 'غير محظور عام' end
if DevHid:sismember(Twix..'Hid:MuteAll:',result.id_) then muteall = 'مكتوم عام' else muteall = 'غير مكتوم عام' end
if DevHid:sismember(Twix..'Hid:Tkeed:',result.id_) then tkeed = 'مقيد' else tkeed = 'غير مقيد' end
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الحظر العام 𓄂 '..banall..'\n⸙ ¦ الكتم العام 𓄂 '..muteall..'\n⸙ ¦ الحظر 𓄂 '..banned..'\n⸙ ¦ الكتم 𓄂 '..muted..'\n⸙ ¦ التقيد 𓄂 '..tkeed..'', 1, 'md')  
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')  
end
end
resolve_username(username,kshf_by_username) 
end
if text == 'رفع القيود' and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) and ChCheck(msg) then 
function unbanreply(extra, result, success) 
if tonumber(result.sender_user_id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
ReplyStatus(msg,result.sender_user_id_,"Reply","⸙ ¦ تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..result.sender_user_id_.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevHid:srem(Twix..'Hid:Tkeed:'..msg.chat_id_,result.sender_user_id_) DevHid:srem(Twix..'Hid:Ban:'..msg.chat_id_,result.sender_user_id_) DevHid:srem(Twix..'Hid:Muted:'..msg.chat_id_,result.sender_user_id_)   
end
getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply) 
end
if text and text:match('^رفع القيود (%d+)') and Admin(msg) and ChCheck(msg) then 
local user = text:match('رفع القيود (%d+)') 
if tonumber(user) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
tdcli_function ({ID = "GetUser",user_id_ = user},function(arg,data) 
if data and data.code_ and data.code_ == 6 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لم استطع استخراج المعلومات', 1, 'md') 
return false  
end
ReplyStatus(msg,user,"Reply","⸙ ¦ تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..user.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevHid:srem(Twix..'Hid:Tkeed:'..msg.chat_id_,user) DevHid:srem(Twix..'Hid:Ban:'..msg.chat_id_,user) DevHid:srem(Twix..'Hid:Muted:'..msg.chat_id_,user)   
end,nil)  
end
if text and text:match('^رفع القيود @(.*)') and Admin(msg) and ChCheck(msg) then  
local username = text:match('رفع القيود @(.*)')  
function unbanusername(extra,result,success)  
if result and result.message_ and result.message_ == "USERNAME_NOT_OCCUPIED" then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *المعرف غير صحيح*', 1, 'md')  
return false  
end
if result and result.type_ and result.type_.channel_ and result.type_.channel_.ID == "Channel" then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا معرف قناة وليس معرف حساب', 1, 'md') 
return false  
end
if tonumber(result.id_) == tonumber(Twix) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ انا البوت وليس لدي قيود', 1, 'md')  
return false  
end 
tdcli_function ({ID = "GetUser",user_id_ = result.id_},function(arg,data) 
if data and data.code_ and data.code_ == 6 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لم استطع استخراج المعلومات', 1, 'md') 
return false  
end
ReplyStatus(msg,result.id_,"Reply","⸙ ¦ تم رفع قيوده")  
HTTPS.request("https://api.telegram.org/bot" .. TokenBot .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..result.id_.. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")  
DevHid:srem(Twix..'Hid:Tkeed:'..msg.chat_id_,result.id_) DevHid:srem(Twix..'Hid:Ban:'..msg.chat_id_,result.id_) DevHid:srem(Twix..'Hid:Muted:'..msg.chat_id_,result.id_)   
end,nil)   
end  
resolve_username(username,unbanusername) 
end 
--     Source Twix     --
if Manager(msg) then
if text and text:match("^تغيير الايدي$") and ChCheck(msg) or text and text:match("^تغير الايدي$") and ChCheck(msg) then 
local List = {
[[
゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .
゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .
゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .
゠𝙸𝙳 𖨈 #id 𖥲 .
]],
[[
➭- 𝒔𝒕𝒂𓂅 #stast 𓍯. 💕
➮- 𝒖𝒔𝒆𝒓𓂅 #username 𓍯. 💕
➭- 𝒎𝒔𝒈𝒆𓂅 #msgs 𓍯. 💕
➭- 𝒊𝒅 𓂅 #id 𓍯. 💕
]],
[[
⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 𝑻𝒐 𝑮𝒓𝒐𝒖𝒑 ★
• 🖤 | 𝑼𝑬𝑺 : #username ‌‌‏⚚
• 🖤 | 𝑺𝑻𝑨 : #stast 🧙🏻‍♂️ ☥
• 🖤 | 𝑰𝑫 : #id ‌‌‏♕
• 🖤 | 𝑴𝑺𝑮 : #msgs 𓆊
]],
[[
┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .
├ 𝐌𝐒𝐆 𖤱 #msgs 𖦴 .
├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .
└ 𝐈𝐃 𖤱 #id 𖦴 .
]],
[[
𓄼🇮🇶 𝑼𝒔𝒆𝒓𝑵𝒂𝒎𝒆 : #username 
𓄼🇮🇶 𝑺𝒕𝒂𝒔𝒕 : #stast 
𓄼🇮🇶 𝒊𝒅 : #id 
𓄼🇮🇶 𝑮𝒂𝒎𝒆𝑺 : #game 
𓄼🇮🇶 𝑴𝒔𝒈𝒔 : #msgs
]],
[[
➞: 𝒔𝒕𝒂𓂅 #stast 𓍯➸💞.
➞: 𝒖𝒔𝒆𝒓𓂅 #username 𓍯➸💞.
➞: 𝒎𝒔𝒈𝒆𓂅 #msgs 𓍯➸💞.
➞: 𝒊𝒅 𓂅 #id 𓍯➸💞.
]],
[[
☆•𝐮𝐬𝐞𝐫 : #username 𖣬  
☆•𝐦𝐬𝐠  : #msgs 𖣬 
☆•𝐬𝐭𝐚 : #stast 𖣬 
☆•𝐢𝐝  : #id 𖣬
]],
[[
- 𓏬 𝐔𝐬𝐄𝐫 : #username 𓂅 .
- 𓏬 𝐌𝐬𝐆  : #msgs 𓂅 .
- 𓏬 𝐒𝐭𝐀 : #stast 𓂅 .
- 𓏬 𝐈𝐃 : #id 𓂅 .
]],
[[
.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username  
.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast  
.𖣂 𝙡𝘿 , #id  
.𖣂 𝙂𝙖𝙢𝙨 , #game 
.𖣂 𝙢𝙨𝙂𝙨 , #msgs
]],
[[
⸙ ¦ 𝐔𝐒𝐄𝐑 ↬ #username 
⸙ ¦ 𝐈𝐃 ↬ #id
⸙ ¦ 𝐒𝐓𝐀𝐒𝐓 ↬ #stast
⸙ ¦ 𝐀𝐔𝐓𝐎 ↬ #cont 
⸙ ¦ 𝐌𝐀𝐒𝐆 ↬ #msgs
⸙ ¦ 𝐆𝐀𝐌𝐄 ↬ #game
]],
[[
ᯓ 𝗨𝗦𝗘𝗥𝗡𝗮𝗺𝗘 . #username 🇺🇸 ꙰
ᯓ 𝗦𝗧𝗮𝗦𝗧 . #stast 🇺🇸 ꙰
ᯓ 𝗜𝗗 . #id 🇺🇸 ꙰
ᯓ 𝗚𝗮𝗺𝗘𝗦 . #game 🇺🇸 ꙰
ᯓ 𝗺𝗦𝗚𝗦 . #msgs 🇺🇸 ꙰
]],
[[
- ᴜѕᴇʀɴᴀᴍᴇ ➥• #username .
- ᴍѕɢѕ ➥• #msgs .
- ѕᴛᴀᴛѕ ➥• #stast .
- ʏᴏᴜʀ ɪᴅ ➥• #id  .
- ᴇᴅɪᴛ ᴍsɢ ➥• #edit .
- ᴅᴇᴛᴀɪʟs ➥• #auto . 
- ɢᴀᴍᴇ ➥• #game .
]]}
local Text_Rand = List[math.random(#List)]
DevHid:set(Twix.."Hid:GpIds:Text"..msg.chat_id_,Text_Rand)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم تغير كليشة الايدي")  
end
--     Source Twix     --
if SecondSudo(msg) then
if text and text:match("^تعيين الايدي العام$") or text and text:match("^تعين الايدي العام$") or text and text:match("^تعيين كليشة الايدي$") then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ رجائا اتبع التعليمات للتعيين \n⸙ ¦ لطبع كليشة الايدي ارسل كليشه تحتوي على النصوص التي باللغه الانجليزيه ادناه 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ لطبع المعرف\n `#id` ↬ لطبع الايدي \n `#photos` ↬ لطبع عدد الصور \n `#stast` ↬ لطبع الرتب \n `#msgs` ↬ لطبع عدد الرسائل \n `#msgday` ↬ لطبع الرسائل اليوميه \n `#CustomTitle` ↬ لطبع اللقب \n `#bio` ↬ لطبع البايو \n `#auto` ↬ لطبع التفاعل \n `#game` ↬ لطبع عدد النقاط \n `#cont` ↬ لطبع عدد الجهات \n `#edit` ↬ لطبع عدد السحكات \n `#Description` ↬ لطبع تعليق الصور\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉', 1, 'md')
DevHid:set("Twix:New:id:"..Twix..msg.sender_user_id_,'HidTwixTEAM')
return "HidTwixTEAM"
end
if text and DevHid:get("Twix:New:id:"..Twix..msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء حفظ كليشة الايدي', 1, 'md')
DevHid:del("Twix:New:id:"..Twix..msg.sender_user_id_)
return false
end
DevHid:del("Twix:New:id:"..Twix..msg.sender_user_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ كليشة الايدي العامه', 1, 'md')
DevHid:set(Twix.."Hid:AllIds:Text",text)
return false
end
if text and text:match("^حذف الايدي العام$") or text and text:match("^مسح الايدي العام$") or text and text:match("^حذف كليشة الايدي$") then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف كليشة الايدي العامه")  
DevHid:del(Twix.."Hid:AllIds:Text")
end
end
--     Source Twix     --
if text and text:match("^تعيين الايدي$") and ChCheck(msg) or text and text:match("^تعين الايدي$") and ChCheck(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ رجائا اتبع التعليمات للتعيين \n⸙ ¦ لطبع كليشة الايدي ارسل كليشه تحتوي على النصوص التي باللغه الانجليزيه ادناه 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ لطبع المعرف\n `#id` ↬ لطبع الايدي \n `#photos` ↬ لطبع عدد الصور \n `#stast` ↬ لطبع الرتب \n `#msgs` ↬ لطبع عدد الرسائل \n `#msgday` ↬ لطبع الرسائل اليوميه \n `#CustomTitle` ↬ لطبع اللقب \n `#bio` ↬ لطبع البايو \n `#auto` ↬ لطبع التفاعل \n `#game` ↬ لطبع عدد النقاط \n `#cont` ↬ لطبع عدد الجهات \n `#edit` ↬ لطبع عدد السحكات \n `#Description` ↬ لطبع تعليق الصور\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉', 1, 'md')
DevHid:set("Twix:New:id:"..Twix..msg.chat_id_..msg.sender_user_id_,'HidTwixTEAM')
return "HidTwixTEAM"
end
if text and Manager(msg) and DevHid:get("Twix:New:id:"..Twix..msg.chat_id_..msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء حفظ كليشة الايدي', 1, 'md')
DevHid:del("Twix:New:id:"..Twix..msg.chat_id_..msg.sender_user_id_)
return false
end
DevHid:del("Twix:New:id:"..Twix..msg.chat_id_..msg.sender_user_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ الكليشه الجديده', 1, 'md')
DevHid:set(Twix.."Hid:GpIds:Text"..msg.chat_id_,text)
return false
end
if text and text:match("^حذف الايدي$") and ChCheck(msg) or text and text:match("^مسح الايدي$") and ChCheck(msg) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف كليشة الايدي")  
DevHid:del(Twix.."Hid:GpIds:Text"..msg.chat_id_)
end
end
--     Source Twix     --
if msg.reply_to_message_id_ ~= 0 then
return ""
else
if text and (text:match("^ايدي$") or text:match("^id$") or text:match("^Id$")) and ChCheck(msg) then
function HidTwixTEAM(extra,abbas,success)
if abbas.username_ then username = '@'..abbas.username_ else username = 'لا يوجد' end
if GetCustomTitle(msg.sender_user_id_,msg.chat_id_) ~= false then CustomTitle = GetCustomTitle(msg.sender_user_id_,msg.chat_id_) else CustomTitle = 'لا يوجد' end
local function getpro(extra, abbas, success) 
local msgsday = DevHid:get(Twix..'Hid:UsersMsgs'..Twix..os.date('%d')..':'..msg.chat_id_..':'..msg.sender_user_id_) or 0
local edit_msg = DevHid:get(Twix..'Hid:EditMsg'..msg.chat_id_..msg.sender_user_id_) or 0
local user_msgs = DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_)
local user_nkt = tonumber(DevHid:get(Twix..'Hid:GamesNumber'..msg.chat_id_..msg.sender_user_id_) or 0)
local cont = (tonumber(DevHid:get(Twix..'Hid:ContactNumber'..msg.chat_id_..':'..msg.sender_user_id_)) or 0)
local msguser = tonumber(DevHid:get(Twix..'Hid:UsersMsgs'..msg.chat_id_..':'..msg.sender_user_id_))
local Texting = {"مو صوره ظيم بالنبي ،🤤💞","مقتنع بصورتك !؟ 😹🖤","ملاك وناسيك بكروبنه ،🤤💞","وفالله ،🤤💞","كشخه برب ،😉🤍","لزكت بيها دغيرها عاد ،😒😕","صورتك مامرتاحلها ،🙄😶","حلغوم والله ،🥺💘","مو صوره غنبله براسها ٦٠ حظ ،😹🤍"}
local Description = Texting[math.random(#Texting)]
if abbas.photos_[0] then
if not DevHid:get(Twix..'Hid:Lock:Id'..msg.chat_id_) then 
if not DevHid:get(Twix..'Hid:Lock:Id:Photo'..msg.chat_id_) then 
if DevHid:get(Twix.."Hid:AllIds:Text") then
newpicid = DevHid:get(Twix.."Hid:AllIds:Text")
newpicid = newpicid:gsub('#username',(username or 'لا يوجد'))
newpicid = newpicid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
newpicid = newpicid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
newpicid = newpicid:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
newpicid = newpicid:gsub('#game',(user_nkt or 'لا يوجد'))
newpicid = newpicid:gsub('#edit',(edit_msg or 'لا يوجد'))
newpicid = newpicid:gsub('#cont',(cont or 'لا يوجد'))
newpicid = newpicid:gsub('#msgs',(user_msgs or 'لا يوجد'))
newpicid = newpicid:gsub('#msgday',(msgsday or 'لا يوجد'))
newpicid = newpicid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
newpicid = newpicid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
newpicid = newpicid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
newpicid = newpicid:gsub('#Description',(Description or 'لا يوجد'))
else
newpicid = "⸙ ¦ "..Description.."\n⸙ ¦ معرفك 𓄂 ❨ "..username.." ❩\n⸙ ¦ ايديك 𓄂 ❨ "..msg.sender_user_id_.." ❩\n⸙ ¦ رتبتك 𓄂 "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⸙ ¦ رسائلك 𓄂 ❨ "..user_msgs.." ❩\n⸙ ¦ سحكاتك 𓄂 ❨ "..edit_msg.." ❩\n⸙ ¦ تفاعلك 𓄂 "..formsgs(msguser).."\n⸙ ¦ نقاطك 𓄂 ❨ "..user_nkt.." ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
end 
if not DevHid:get(Twix.."Hid:GpIds:Text"..msg.chat_id_) then 
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, abbas.photos_[0].sizes_[1].photo_.persistent_id_,newpicid,msg.id_,msg.id_.."")
else 
local new_id = DevHid:get(Twix.."Hid:GpIds:Text"..msg.chat_id_)
local new_id = new_id:gsub('#username',(username or 'لا يوجد'))
local new_id = new_id:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
local new_id = new_id:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#photos',(abbas.total_count_ or '')) 
local new_id = new_id:gsub('#game',(user_nkt or 'لا يوجد'))
local new_id = new_id:gsub('#edit',(edit_msg or 'لا يوجد'))
local new_id = new_id:gsub('#cont',(cont or 'لا يوجد'))
local new_id = new_id:gsub('#msgs',(user_msgs or 'لا يوجد'))
local new_id = new_id:gsub('#msgday',(msgsday or 'لا يوجد'))
local new_id = new_id:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
local new_id = new_id:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
local new_id = new_id:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#Description',(Description or 'لا يوجد'))
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, abbas.photos_[0].sizes_[1].photo_.persistent_id_,new_id,msg.id_,msg.id_.."")
end
else
if DevHid:get(Twix.."Hid:AllIds:Text") then
newallid = DevHid:get(Twix.."Hid:AllIds:Text")
newallid = newallid:gsub('#username',(username or 'لا يوجد'))
newallid = newallid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
newallid = newallid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
newallid = newallid:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
newallid = newallid:gsub('#game',(user_nkt or 'لا يوجد'))
newallid = newallid:gsub('#edit',(edit_msg or 'لا يوجد'))
newallid = newallid:gsub('#cont',(cont or 'لا يوجد'))
newallid = newallid:gsub('#msgs',(user_msgs or 'لا يوجد'))
newallid = newallid:gsub('#msgday',(msgsday or 'لا يوجد'))
newallid = newallid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
newallid = newallid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
newallid = newallid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
newallid = newallid:gsub('#Description',(Description or 'لا يوجد'))
else
newallid = "⸙ ¦ معرفك 𓄂 ❨ "..username.." ❩\n⸙ ¦ ايديك 𓄂 ❨ "..msg.sender_user_id_.." ❩\n⸙ ¦ رتبتك 𓄂 "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⸙ ¦ رسائلك 𓄂 ❨ "..user_msgs.." ❩\n⸙ ¦ سحكاتك 𓄂 ❨ "..edit_msg.." ❩\n⸙ ¦ تفاعلك 𓄂 "..formsgs(msguser).."\n⸙ ¦ نقاطك 𓄂 ❨ "..user_nkt.." ❩"
end 
if not DevHid:get(Twix.."Hid:GpIds:Text"..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, newallid, 1, 'html')
else
local new_id = DevHid:get(Twix.."Hid:GpIds:Text"..msg.chat_id_)
local new_id = new_id:gsub('#username',(username or 'لا يوجد'))
local new_id = new_id:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
local new_id = new_id:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
local new_id = new_id:gsub('#game',(user_nkt or 'لا يوجد'))
local new_id = new_id:gsub('#edit',(edit_msg or 'لا يوجد'))
local new_id = new_id:gsub('#cont',(cont or 'لا يوجد'))
local new_id = new_id:gsub('#msgs',(user_msgs or 'لا يوجد'))
local new_id = new_id:gsub('#msgday',(msgsday or 'لا يوجد'))
local new_id = new_id:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
local new_id = new_id:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
local new_id = new_id:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
local new_id = new_id:gsub('#Description',(Description or 'لا يوجد'))
Dev_Hid(msg.chat_id_, msg.id_, 1, new_id, 1, 'html')  
end
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عذرا الايدي معطل ', 1, 'md')
end
else
if DevHid:get(Twix.."Hid:AllIds:Text") then
notpicid = DevHid:get(Twix.."Hid:AllIds:Text")
notpicid = notpicid:gsub('#username',(username or 'لا يوجد'))
notpicid = notpicid:gsub('#CustomTitle',(CustomTitle or 'لا يوجد'))
notpicid = notpicid:gsub('#bio',(GetBio(msg.sender_user_id_) or 'لا يوجد'))
notpicid = notpicid:gsub('#photos',(abbas.total_count_ or 'لا يوجد')) 
notpicid = notpicid:gsub('#game',(user_nkt or 'لا يوجد'))
notpicid = notpicid:gsub('#edit',(edit_msg or 'لا يوجد'))
notpicid = notpicid:gsub('#cont',(cont or 'لا يوجد'))
notpicid = notpicid:gsub('#msgs',(user_msgs or 'لا يوجد'))
notpicid = notpicid:gsub('#msgday',(msgsday or 'لا يوجد'))
notpicid = notpicid:gsub('#id',(msg.sender_user_id_ or 'لا يوجد'))
notpicid = notpicid:gsub('#auto',(formsgs(msguser) or 'لا يوجد'))
notpicid = notpicid:gsub('#stast',(IdRank(msg.sender_user_id_, msg.chat_id_) or 'لا يوجد'))
notpicid = notpicid:gsub('#Description',(Description or 'لا يوجد'))
else
notpicid = "⸙ ¦ لا استطيع عرض صورتك لانك قمت بحظر البوت او انك لاتمتلك صوره في بروفايلك\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ معرفك 𓄂 ❨ "..username.." ❩\n⸙ ¦ ايديك 𓄂 ❨ "..msg.sender_user_id_.." ❩\n⸙ ¦ رتبتك 𓄂 "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⸙ ¦ رسائلك 𓄂 ❨ "..user_msgs.." ❩\n⸙ ¦ سحكاتك 𓄂 ❨ "..edit_msg.." ❩\n⸙ ¦ تفاعلك 𓄂 "..formsgs(msguser).."\n⸙ ¦ نقاطك 𓄂 ❨ "..user_nkt.." ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
end 
if not DevHid:get(Twix..'Hid:Lock:Id'..msg.chat_id_) then
if not DevHid:get(Twix..'Hid:Lock:Id:Photo'..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, notpicid, 1, 'html')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ معرفك 𓄂 ❨ "..username.." ❩\n⸙ ¦ ايديك 𓄂 ❨ "..msg.sender_user_id_.." ❩\n⸙ ¦ رتبتك 𓄂 "..IdRank(msg.sender_user_id_, msg.chat_id_).."\n⸙ ¦ رسائلك 𓄂 ❨ "..user_msgs.." ❩\n⸙ ¦ سحكاتك 𓄂 ❨ "..edit_msg.." ❩\n⸙ ¦ رسائلك 𓄂 ❨ "..user_msgs.." ❩\n⸙ ¦ تفاعلك 𓄂 "..formsgs(msguser).."\n⸙ ¦ نقاطك 𓄂 ❨ "..user_nkt.." ❩", 1, 'md')
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عذرا الايدي معطل', 1, 'md')
end end end
tdcli_function ({ ID = "GetUserProfilePhotos", user_id_ = msg.sender_user_id_, offset_ = 0, limit_ = 1 }, getpro, nil)
end
getUser(msg.sender_user_id_, HidTwixTEAM)
end
end 
--     Source Twix     --
if ChatType == 'sp' or ChatType == 'gp'  then
if Admin(msg) then
if text and text:match("^قفل (.*)$") then
local LockText = {string.match(text, "^(قفل) (.*)$")}
if LockText[2] == "التعديل" then
if not DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التعديل")  
DevHid:set(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ التعديل بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "التعديل الميديا" or LockText[2] == "تعديل الميديا" then
if not DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل تعديل الميديا")  
DevHid:set(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تعديل الميديا بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفارسيه" then
if not DevHid:get(Twix..'Hid:Lock:Farsi'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الفارسيه")  
DevHid:set(Twix..'Hid:Lock:Farsi'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفارسيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفشار" then
if DevHid:get(Twix..'Hid:Lock:Fshar'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الفشار")  
DevHid:del(Twix..'Hid:Lock:Fshar'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفشار بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الطائفيه" then
if DevHid:get(Twix..'Hid:Lock:Taf'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الطائفيه")  
DevHid:del(Twix..'Hid:Lock:Taf'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الطائفيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الكفر" then
if DevHid:get(Twix..'Hid:Lock:Kfr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الكفر")  
DevHid:del(Twix..'Hid:Lock:Kfr'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الكفر بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفارسيه بالطرد" then
if not DevHid:get(Twix..'Hid:Lock:FarsiBan'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الفارسيه بالطرد")  
DevHid:set(Twix..'Hid:Lock:FarsiBan'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفارسيه بالطرد بالفعل مقفله ', 1, 'md')
end
end
if LockText[2] == "البوتات" or LockText[2] == "البوتات بالحذف" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل البوتات بالحذف")  
DevHid:set(Twix.."Hid:Lock:Bots"..msg.chat_id_,"del")  
end
if LockText[2] == "البوتات بالطرد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل البوتات بالطرد")  
DevHid:set(Twix.."Hid:Lock:Bots"..msg.chat_id_,"kick")  
end
if LockText[2] == "البوتات بالتقييد" or LockText[2] == "البوتات بالتقيد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل البوتات بالتقيد")  
DevHid:set(Twix.."Hid:Lock:Bots"..msg.chat_id_,"ked")  
end
if LockText[2] == "التكرار" or LockText[2] == "التكرار بالحذف" then 
DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User","del")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التكرار بالحذف")  
end
if LockText[2] == "التكرار بالطرد" then 
DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User","kick")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التكرار بالطرد")  
end
if LockText[2] == "التكرار بالتقيد" or LockText[2] == "التكرار بالتقييد" then 
DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التكرار بالتقيد")  
end
if LockText[2] == "التكرار بالكتم" then 
DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User","mute")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التكرار بالكتم")  
end
if BasicConstructor(msg) then
if LockText[2] == "التثبيت" then
if not DevHid:get(Twix..'Hid:Lock:Pin'..msg.chat_id_) then
tdcli_function ({ ID = "GetChannelFull",  channel_id_ = msg.chat_id_:gsub("-100","") }, function(arg,data)  DevHid:set(Twix.."Hid:PinnedMsg"..msg.chat_id_,data.pinned_message_id_)  end,nil)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التثبيت")  
DevHid:set(Twix..'Hid:Lock:Pin'..msg.chat_id_,true)
DevHid:sadd(Twix.."Hid:Lock:Pinpin",msg.chat_id_) 
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ التثبيت بالفعل مقفل في المجموعه', 1, 'md')
end end end
end
end
end
--     Source Twix     --
if Admin(msg) then
if text and (text:match("^ضع تكرار (%d+)$") or text:match("^وضع تكرار (%d+)$")) then   
local TextSpam = text:match("ضع تكرار (%d+)$") or text:match("وضع تكرار (%d+)$")
if tonumber(TextSpam) < 2 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ قم بتحديد عدد اكبر من 2 للتكرار', 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم وضع عدد التكرار 𓄂 '..TextSpam, 1, 'md')
DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Num:Spam" ,TextSpam) 
end
end
if text and (text:match("^ضع زمن التكرار (%d+)$") or text:match("^وضع زمن التكرار (%d+)$")) then  
local TextSpam = text:match("ضع زمن التكرار (%d+)$") or text:match("وضع زمن التكرار (%d+)$")
DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Num:Spam:Time" ,TextSpam) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم وضع زمن التكرار 𓄂 '..TextSpam, 1, 'md')
end
--     Source Twix     --
if Manager(msg) then
if text and text == 'تفعيل الايدي بالصوره' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Id:Photo'..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الايدي بالصوره بالتاكيد مفعل', 1, 'md')
else
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الايدي بالصوره'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:Id:Photo'..msg.chat_id_)
end end
if text and text == 'تعطيل الايدي بالصوره' and ChCheck(msg) then
if DevHid:get(Twix..'Hid:Lock:Id:Photo'..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الايدي بالصوره بالتاكيد معطل', 1, 'md')
else
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الايدي بالصوره'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:Id:Photo'..msg.chat_id_,true)
end end 

if text and text == 'تفعيل الايدي' and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Lock:Id'..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الايدي بالتاكيد مفعل ', 1, 'md')
else
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الايدي بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:Id'..msg.chat_id_)
end end 
if text and text == 'تعطيل الايدي' and ChCheck(msg) then
if DevHid:get(Twix..'Hid:Lock:Id'..msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الايدي بالتاكيد معطل ', 1, 'md')
else
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الايدي بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:Id'..msg.chat_id_,true)
end end
end
--     Source Twix     --
if text == 'ضع رابط' or text == 'وضع رابط' or text == 'ضع الرابط' or text == 'وضع الرابط' then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل رابط المجموعه او رابط قناة المجموعه', 1, 'md')
DevHid:setex(Twix.."Hid:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_,300,true) 
end
if text == 'انشاء رابط' or text == 'انشاء الرابط' then
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if not DevHid:get(Twix.."Hid:Groups:Links"..msg.chat_id_)  then 
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
DevHid:set(Twix.."Hid:Groups:Links"..msg.chat_id_,LinkGroup) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم انشاء رابط جديد ارسل 𓄂 الرابط', 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ليست لدي صلاحية دعوة المستخدمين عبر الرابط يرجى التحقق من الصلاحيات', 1, 'md')
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل رابط المجموعه او رابط قناة المجموعه', 1, 'md')
DevHid:setex(Twix.."Hid:Set:Groups:Links"..msg.chat_id_..""..msg.sender_user_id_,300,true) 
end
end
end
--     Source Twix     --
if Admin(msg) then
if text and text:match("^تفعيل الترحيب$") and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الترحيب بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix.."Hid:Lock:Welcome"..msg.chat_id_,true)
end
if text and text:match("^تعطيل الترحيب$") and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الترحيب بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix.."Hid:Lock:Welcome"..msg.chat_id_)
end
if DevHid:get(Twix..'Hid:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_) then 
if text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء حفظ كليشة الترحيب', 1, 'md')
DevHid:del(Twix..'Hid:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevHid:del(Twix..'Hid:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Groups:Welcomes'..msg.chat_id_,text)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ كليشة الترحيب', 1, 'md')
return false   
end
if text and text:match("^ضع ترحيب$") and ChCheck(msg) or text and text:match("^وضع ترحيب$") and ChCheck(msg) or text and text:match("^اضف ترحيب$") and ChCheck(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل لي الترحيب الان\n⸙ ¦ تستطيع اضافة مايلي 𓄂 ⤈\n⸙ ¦ دالة عرض الاسم 𓄂 firstname\n⸙ ¦ دالة عرض المعرف 𓄂 username', 1, 'md')
DevHid:set(Twix..'Hid:setwelcome'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
if text and text:match("^حذف الترحيب$") and ChCheck(msg) or text and text:match("^حذف ترحيب$") and ChCheck(msg) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف الترحيب")  
DevHid:del(Twix..'Hid:Groups:Welcomes'..msg.chat_id_)
end
if text and text:match("^جلب الترحيب$") and ChCheck(msg) or text and text:match("^جلب ترحيب$") and ChCheck(msg) or text and text:match("^الترحيب$") and ChCheck(msg) then
local Welcomes = DevHid:get(Twix..'Hid:Groups:Welcomes'..msg.chat_id_)
local Welcomes = Welcomes:gsub('"',"") local Welcomes = Welcomes:gsub("'","") local Welcomes = Welcomes:gsub(",","") local Welcomes = Welcomes:gsub("*","") local Welcomes = Welcomes:gsub(";","") local Welcomes = Welcomes:gsub("`","") local Welcomes = Welcomes:gsub("{","") local Welcomes = Welcomes:gsub("}","") 
if Welcomes then
Dev_Hid(msg.chat_id_, msg.id_, 1, Welcomes, 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لم يتم وضع الترحيب \n⸙ ¦ ارسل 𓄂 ضع ترحيب للحفظ ', 1, 'md')
end
end
--     Source Twix     --
if DevHid:get(Twix..'Hid:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_) then  
if text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء حفظ الوصف", 1, 'md')
DevHid:del(Twix..'Hid:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevHid:del(Twix..'Hid:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_)
https.request('https://api.telegram.org/bot'..TokenBot..'/setChatDescription?chat_id='..msg.chat_id_..'&description='..text) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تغيير وصف المجموعه', 1, 'md')
return false  
end 
if text and text:match("^ضع وصف$") and ChCheck(msg) or text and text:match("^وضع وصف$") and ChCheck(msg) then  
DevHid:set(Twix..'Hid:SetDescription'..msg.chat_id_..':'..msg.sender_user_id_,true)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل لي الوصف الان', 1, 'md')
end
--     Source Twix     --
if text and text == "منع" and msg.reply_to_message_id_ == 0 and ChCheck(msg) then       
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل لي الكلمه الان", 1, 'md') 
DevHid:set(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_,"add")  
return false  
end    
if DevHid:get(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_) == "add" then
if text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر المنع', 1, 'md')
DevHid:del(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
return false  
end   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم منع الكلمه 𓄂 "..text, 1, 'html')
DevHid:del(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
DevHid:hset(Twix..'Hid:Filters:'..msg.chat_id_, text,'newword')
return false
end
if text and text == "الغاء منع" and msg.reply_to_message_id_ == 0 and ChCheck(msg) then       
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل لي الكلمه الان", 1, 'md') 
DevHid:set(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_,"del")  
return false  
end    
if DevHid:get(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_) == "del" then   
if text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر الغاء المنع', 1, 'md')
DevHid:del(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
return false  
end   
if not DevHid:hget(Twix..'Hid:Filters:'..msg.chat_id_, text) then  
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ الكلمه 𓄂 "..text.." غير ممنوعه", 1, 'html')
DevHid:del(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
else
DevHid:hdel(Twix..'Hid:Filters:'..msg.chat_id_, text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ الكلمه 𓄂 "..text.." تم الغاء منعها", 1, 'html')
DevHid:del(Twix.."Hid:SetFilters"..msg.sender_user_id_..msg.chat_id_)  
end
return false
end
--     Source Twix     --
if SudoBot(msg) then
if text and text == "الاحصائيات" and ChCheck(msg) or text and text == "𓄂 الاحصائيات ⸙" then
local gps = DevHid:scard(Twix.."Hid:Groups") local users = DevHid:scard(Twix.."Hid:Users") 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ احصائيات البوت 𓄂 ⤈\n⸙ ¦ عدد المشتركين 𓄂 ❨ '..users..' ❩\n⸙ ¦ عدد المجموعات 𓄂 ❨ '..gps..' ❩', 1, 'md')
end
if text and text == "المشتركين" and ChCheck(msg) or text and text == "𓄂 المشتركين ⸙" then
local users = DevHid:scard(Twix.."Hid:Users")
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عدد المشتركين 𓄂 ❨ '..users..' ❩', 1, 'md')
end
if text and text == "المجموعات" and ChCheck(msg) or text and text == "𓄂 المجموعات ⸙" then
local gps = DevHid:scard(Twix.."Hid:Groups")
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عدد المجموعات 𓄂 ❨ '..gps..' ❩', 1, 'md')
end
end
--     Source Twix     --
if text and text:match('^تنظيف (%d+)$') and ChCheck(msg) then  
if not DevHid:get(Twix..'Delete:Time'..msg.chat_id_..':'..msg.sender_user_id_) then  
local Number = tonumber(text:match('^تنظيف (%d+)$')) 
if Number > 1000 then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لاتستطيع تنظيف اكثر من 1000 رساله', 1, 'md')
return false  
end  
local Message = msg.id_
for i=1,tonumber(Number) do
DeleteMessage(msg.chat_id_,{[0]=Message})
Message = Message - 1048576 
end
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تنظيف *'..Number..'* من الرسائل', 1, 'md')
DevHid:setex(Twix..'Delete:Time'..msg.chat_id_..':'..msg.sender_user_id_,300,true)
end 
end
if text == "تنظيف المشتركين" and SecondSudo(msg) and ChCheck(msg) then 
local pv = DevHid:smembers(Twix.."Hid:Users")
local sendok = 0
for i = 1, #pv do
tdcli_function({ID='GetChat',chat_id_ = pv[i]
},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",  
chat_id_ = pv[i], action_ = {  ID = "SendMessageTypingAction", progress_ = 100} 
},function(arg,data) 
if data.ID and data.ID == "Ok" then
else
DevHid:srem(Twix.."Hid:Users",pv[i])
sendok = sendok + 1
end
if #pv == i then 
if sendok == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ *لا يوجد مشتركين وهميين*', 1, 'md')
else
local ok = #pv - sendok
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عدد المشتركين الان 𓄂 { '..#pv..' }\n⸙ ¦ تم حذف 𓄂 { '..sendok..' } من المشتركين\n⸙ ¦ العدد الحقيقي الان  𓄂 ( '..ok..' ) \n', 1, 'md')
end
end
end,nil)
end,nil)
end
return false
end
--     Source Twix     --
if text == "تنظيف الكروبات" and SecondSudo(msg) and ChCheck(msg) or text == "تنظيف المجموعات" and SecondSudo(msg) and ChCheck(msg) then 
local group = DevHid:smembers(Twix.."Hid:Groups")
local w = 0
local q = 0
for i = 1, #group do
tdcli_function({ID='GetChat',chat_id_ = group[i]
},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
DevHid:srem(Twix.."Hid:Groups",group[i]) 
changeChatMemberStatus(group[i], Twix, "Left")
w = w + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
DevHid:srem(Twix.."Hid:Groups",group[i]) 
q = q + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
DevHid:srem(Twix.."Hid:Groups",group[i]) 
q = q + 1
end
if data and data.code_ and data.code_ == 400 then
DevHid:srem(Twix.."Hid:Groups",group[i]) 
w = w + 1
end
if #group == i then 
if (w + q) == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ *لاتوجد مجموعات وهميه*', 1, 'md')   
else
local Twixgp2 = (w + q)
local Twixgp3 = #group - Twixgp2
if q == 0 then
Twixgp2 = ''
else
Twixgp2 = '\n⸙ ¦ تم حذف 𓄂 { '..q..' } مجموعه من البوت'
end
if w == 0 then
Twixgp1 = ''
else
Twixgp1 = '\n⸙ ¦ تم حذف 𓄂 { '..w..' } مجموعه بسبب تنزيل البوت الى عضو'
end
Dev_Hid(msg.chat_id_, msg.id_, 1,'⸙ ¦ عدد الكروبات الان 𓄂 { '..#group..' }'..Twixgp1..''..Twixgp2..'\n⸙ ¦ العدد الحقيقي الان  𓄂 ( '..Twixgp3..' ) \n ', 1, 'md')
end end
end,nil)
end
return false
end 
end
--     Source Twix     --
if text == "تفعيل امسح" and Constructor(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل امسح بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:Clean'..msg.chat_id_,true)  
end
if text == "تعطيل امسح" and Constructor(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل امسح بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:Clean'..msg.chat_id_) 
end
if msg and DevHid:get(Twix..'Hid:Lock:Clean'..msg.chat_id_) and DevHid:scard(Twix.."Hid:cleaner"..msg.chat_id_) >= 200 then 
local List = DevHid:smembers(Twix.."Hid:cleaner"..msg.chat_id_)
local Del = 0
for k,v in pairs(List) do
Del = (Del + 1)
local Message = v
DeleteMessage(msg.chat_id_,{[0]=Message})
end
SendText(msg.chat_id_,"⸙ ¦ تم حذف "..Del.." من الميديا تلقائيا",0,'md') 
DevHid:del(Twix.."Hid:cleaner"..msg.chat_id_)
end 
if Cleaner(msg) then
if DevHid:get(Twix..'Hid:Lock:Clean'..msg.chat_id_) then 
if text == "الميديا" and ChCheck(msg) or text == "عدد الميديا" and ChCheck(msg) then 
local M = DevHid:scard(Twix.."Hid:cleaner"..msg.chat_id_)
if M ~= 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ عدد الميديا 𓄂 "..M, 1, 'md') 
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لاتوجد ميديا هنا", 1, 'md') 
end end
if text == "امسح" and ChCheck(msg) or text == "تنظيف ميديا" and ChCheck(msg) or text == "تنظيف الميديا" and ChCheck(msg) then
local List = DevHid:smembers(Twix.."Hid:cleaner"..msg.chat_id_)
local Del = 0
for k,v in pairs(List) do
Del = (Del + 1)
local Message = v
DeleteMessage(msg.chat_id_,{[0]=Message})
end
if Del ~= 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف "..Del.." من الميديا", 1, 'md') 
DevHid:del(Twix.."Hid:cleaner"..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لاتوجد ميديا هنا", 1, 'md') 
end end 
end
end
--     Source Twix     --
if Admin(msg) then
if text == "تنظيف تعديل" or text == "تنظيف التعديل" and ChCheck(msg) then   
Hid_Del = {[0]= msg.id_}
local Message = msg.id_
for i=1,100 do
Message = Message - 1048576
Hid_Del[i] = Message
end
tdcli_function({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Hid_Del},function(arg,data)
new = 0
Hid_Del2 = {}
for i=0 ,data.total_count_ do
if data.messages_[i] and (not data.messages_[i].edit_date_ or data.messages_[i].edit_date_ ~= 0) then
Hid_Del2[new] = data.messages_[i].id_
new = new + 1
end
end
DeleteMessage(msg.chat_id_,Hid_Del2)
end,nil)  
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تنظيف 100 من الرسائل المعدله', 1, 'md')
end
--     Source Twix     --
if ChatType == 'sp' or ChatType == 'gp'  then
if Admin(msg) then
if text and text:match("^فتح (.*)$") then
local UnLockText = {string.match(text, "^(فتح) (.*)$")}
if UnLockText[2] == "التعديل" then
if DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح التعديل")  
DevHid:del(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ التعديل بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "التعديل الميديا" or UnLockText[2] == "تعديل الميديا" then
if DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح تعديل الميديا")  
DevHid:del(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تعديل الميديا بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفارسيه" then
if DevHid:get(Twix..'Hid:Lock:Farsi'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الفارسيه")  
DevHid:del(Twix..'Hid:Lock:Farsi'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفارسيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفشار" then
if not DevHid:get(Twix..'Hid:Lock:Fshar'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الفشار")  
DevHid:set(Twix..'Hid:Lock:Fshar'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفشار بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الطائفيه" then
if not DevHid:get(Twix..'Hid:Lock:Taf'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الطائفيه")  
DevHid:set(Twix..'Hid:Lock:Taf'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الطائفيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الكفر" then
if not DevHid:get(Twix..'Hid:Lock:Kfr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الكفر")  
DevHid:set(Twix..'Hid:Lock:Kfr'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الكفر بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفارسيه بالطرد" then
if DevHid:get(Twix..'Hid:Lock:FarsiBan'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الفارسيه بالطرد")  
DevHid:del(Twix..'Hid:Lock:FarsiBan'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفارسيه بالطرد بالفعل مفتوحه', 1, 'md')
end
end
if UnLockText[2] == "البوتات" or UnLockText[2] == "البوتات بالطرد" or UnLockText[2] == "البوتات بالتقييد" or UnLockText[2] == "البوتات بالتقيد" then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح البوتات")  
DevHid:del(Twix.."Hid:Lock:Bots"..msg.chat_id_)  
end
if UnLockText[2] == "التكرار" then 
DevHid:hdel(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User")  
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح التكرار")  
end
if BasicConstructor(msg) then
if UnLockText[2] == "التثبيت" then
if DevHid:get(Twix..'Hid:Lock:Pin'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح التثبيت")  
DevHid:del(Twix..'Hid:Lock:Pin'..msg.chat_id_)
DevHid:srem(Twix.."Hid:Lock:Pinpin",msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ التثبيت بالفعل مفتوح في المجموعه', 1, 'md')
end end end
end
end
--     Source Twix     --
if Admin(msg) then
if text and text:match("^قفل (.*)$") then
local LockText = {string.match(text, "^(قفل) (.*)$")}
if LockText[2] == "الدردشه" then
if not DevHid:get(Twix..'Hid:Lock:Text'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الدردشه")  
DevHid:set(Twix..'Hid:Lock:Text'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الدردشه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاونلاين" then
if not DevHid:get(Twix..'Hid:Lock:Inline'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الاونلاين")  
DevHid:set(Twix..'Hid:Lock:Inline'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الاونلاين بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الصور" then
if not DevHid:get(Twix..'Hid:Lock:Photo'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الصور")  
DevHid:set(Twix..'Hid:Lock:Photo'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الصور بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الكلايش" then
if not DevHid:get(Twix..'Hid:Lock:Spam'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الكلايش")  
DevHid:set(Twix..'Hid:Lock:Spam'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الكلايش بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الدخول" then
if not DevHid:get(Twix..'Hid:Lock:Join'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الدخول")  
DevHid:set(Twix..'Hid:Lock:Join'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الدخول بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الفيديو" then
if not DevHid:get(Twix..'Hid:Lock:Videos'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الفيديو")  
DevHid:set(Twix..'Hid:Lock:Videos'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفيديو بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "المتحركه" then
if not DevHid:get(Twix..'Hid:Lock:Gifs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل المتحركه")  
DevHid:set(Twix..'Hid:Lock:Gifs'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المتحركه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاغاني" then
if not DevHid:get(Twix..'Hid:Lock:Music'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الاغاني")  
DevHid:set(Twix..'Hid:Lock:Music'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الاغاني بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الصوت" then
if not DevHid:get(Twix..'Hid:Lock:Voice'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الصوت")  
DevHid:set(Twix..'Hid:Lock:Voice'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الصوت بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الروابط" then
if not DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الروابط")  
DevHid:set(Twix..'Hid:Lock:Links'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الروابط بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "المواقع" then
if not DevHid:get(Twix..'Hid:Lock:Location'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل المواقع")  
DevHid:set(Twix..'Hid:Lock:Location'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المواقع بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "المعرف" or LockText[2] == "المعرفات" then
if not DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل المعرفات")  
DevHid:set(Twix..'Hid:Lock:Tags'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المعرفات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الملفات" then
if not DevHid:get(Twix..'Hid:Lock:Document'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الملفات")  
DevHid:set(Twix..'Hid:Lock:Document'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الملفات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الهاشتاك" or LockText[2] == "التاك" then
if not DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الهاشتاك")  
DevHid:set(Twix..'Hid:Lock:Hashtak'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الهاشتاك بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الجهات" then
if not DevHid:get(Twix..'Hid:Lock:Contact'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الجهات")  
DevHid:set(Twix..'Hid:Lock:Contact'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '️⸙ ¦ الجهات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الشبكات" then
if not DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الشبكات")  
DevHid:set(Twix..'Hid:Lock:WebLinks'..msg.chat_id_,true) 
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الشبكات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "العربيه" then
if not DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل العربيه")  
DevHid:set(Twix..'Hid:Lock:Arabic'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العربيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الانكليزيه" then
if not DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الانكليزيه")  
DevHid:set(Twix..'Hid:Lock:English'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الانكليزيه بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الملصقات" then
if not DevHid:get(Twix..'Hid:Lock:Stickers'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الملصقات")  
DevHid:set(Twix..'Hid:Lock:Stickers'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الملصقات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "الماركداون" then
if not DevHid:get(Twix..'Hid:Lock:Markdown'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الماركداون")  
DevHid:set(Twix..'Hid:Lock:Markdown'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الماركداون بالفعل مقفل في المجموعه', 1, 'md')
end
end
if LockText[2] == "الاشعارات" then
if not DevHid:get(Twix..'Hid:Lock:TagServr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل الاشعارات")  
DevHid:set(Twix..'Hid:Lock:TagServr'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الاشعارات بالفعل مقفله في المجموعه', 1, 'md')
end
end
if LockText[2] == "التوجيه" then
if not DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التوجيه")  
DevHid:set(Twix..'Hid:Lock:Forwards'..msg.chat_id_,true)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ التوجيه بالفعل مقفل في المجموعه', 1, 'md')
end
end
end
end
--     Source Twix     --
if Admin(msg) then
if text and text:match("^فتح (.*)$") then
local UnLockText = {string.match(text, "^(فتح) (.*)$")}
if UnLockText[2] == "الدردشه" then
if DevHid:get(Twix..'Hid:Lock:Text'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الدردشه")  
DevHid:del(Twix..'Hid:Lock:Text'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الدردشه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الصور" then
if DevHid:get(Twix..'Hid:Lock:Photo'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الصور")  
DevHid:del(Twix..'Hid:Lock:Photo'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الصور بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الكلايش" then
if DevHid:get(Twix..'Hid:Lock:Spam'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الكلايش")  
DevHid:del(Twix..'Hid:Lock:Spam'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الكلايش بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الدخول" then
if DevHid:get(Twix..'Hid:Lock:Join'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الدخول")  
DevHid:del(Twix..'Hid:Lock:Join'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الدخول بالفعل مفتوح في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الفيديو" then
if DevHid:get(Twix..'Hid:Lock:Videos'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الفيديو")  
DevHid:del(Twix..'Hid:Lock:Videos'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الفيديو بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الملفات" then
if DevHid:get(Twix..'Hid:Lock:Document'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الملفات")  
DevHid:del(Twix..'Hid:Lock:Document'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الملفات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاونلاين" then
if DevHid:get(Twix..'Hid:Lock:Inline'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الاونلاين")  
DevHid:del(Twix..'Hid:Lock:Inline'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الاونلاين بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الماركداون" then
if DevHid:get(Twix..'Hid:Lock:Markdown'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الماركداون")  
DevHid:del(Twix..'Hid:Lock:Markdown'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الماركداون بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المتحركه" then
if DevHid:get(Twix..'Hid:Lock:Gifs'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح المتحركه")  
DevHid:del(Twix..'Hid:Lock:Gifs'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المتحركه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاغاني" then
if DevHid:get(Twix..'Hid:Lock:Music'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الاغاني")  
DevHid:del(Twix..'Hid:Lock:Music'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الاغاني بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الصوت" then
if DevHid:get(Twix..'Hid:Lock:Voice'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الصوت")  
DevHid:del(Twix..'Hid:Lock:Voice'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الصوت بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الروابط" then
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الروابط")  
DevHid:del(Twix..'Hid:Lock:Links'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الروابط بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المواقع" then
if DevHid:get(Twix..'Hid:Lock:Location'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح المواقع")  
DevHid:del(Twix..'Hid:Lock:Location'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المواقع بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "المعرف" or UnLockText[2] == "المعرفات" then
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح المعرفات")  
DevHid:del(Twix..'Hid:Lock:Tags'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المعرفات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الهاشتاك" or UnLockText[2] == "التاك" then
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الهاشتاك")  
DevHid:del(Twix..'Hid:Lock:Hashtak'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الهاشتاك بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الجهات" then
if DevHid:get(Twix..'Hid:Lock:Contact'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الجهات")  
DevHid:del(Twix..'Hid:Lock:Contact'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الجهات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الشبكات" then
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الشبكات")  
DevHid:del(Twix..'Hid:Lock:WebLinks'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الشبكات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "العربيه" then
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح العربيه")  
DevHid:del(Twix..'Hid:Lock:Arabic'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ العربيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الانكليزيه" then
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الانكليزيه")  
DevHid:del(Twix..'Hid:Lock:English'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الانكليزيه بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الاشعارات" then
if DevHid:get(Twix..'Hid:Lock:TagServr'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الاشعارات")  
DevHid:del(Twix..'Hid:Lock:TagServr'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الاشعارات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "الملصقات" then
if DevHid:get(Twix..'Hid:Lock:Stickers'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح الملصقات")  
DevHid:del(Twix..'Hid:Lock:Stickers'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ الملصقات بالفعل مفتوحه في المجموعه', 1, 'md')
end
end
if UnLockText[2] == "التوجيه" then
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح التوجيه")  
DevHid:del(Twix..'Hid:Lock:Forwards'..msg.chat_id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ التوجيه بالفعل مفتوح في المجموعه', 1, 'md')
end
end
end
end
--     Source Twix     --
if text and text:match("^قفل التفليش$") or text and text:match("^تفعيل الحمايه القصوى$") then
if not Constructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمنشئين فقط', 1, 'md')
else
DevHid:set(Twix.."Hid:Lock:Bots"..msg.chat_id_,"del") DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed") 
LockList ={'Hid:Lock:Links','Hid:Lock:Contact','Hid:Lock:Forwards','Hid:Lock:Videos','Hid:Lock:Gifs','Hid:Lock:EditMsgs','Hid:Lock:Stickers','Hid:Lock:Farsi','Hid:Lock:Spam','Hid:Lock:WebLinks','Hid:Lock:Photo'}
for i,Lock in pairs(LockList) do
DevHid:set(Twix..Lock..msg.chat_id_,true)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل التفليش")  
end
end
if text and text:match("^فتح التفليش$") then
if not Constructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمنشئين فقط', 1, 'md')
else
DevHid:hdel(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User") 
UnLockList ={'Hid:Lock:Links','Hid:Lock:Contact','Hid:Lock:Forwards','Hid:Lock:Videos','Hid:Lock:Gifs','Hid:Lock:EditMsgs','Hid:Lock:Stickers','Hid:Lock:Farsi','Hid:Lock:Spam','Hid:Lock:WebLinks','Hid:Lock:Photo'}
for i,UnLock in pairs(UnLockList) do
DevHid:del(Twix..UnLock..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح التفليش")  
end
end
--     Source Twix     --
if text and text:match("^قفل الكل$") then
if not Constructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمنشئين فقط', 1, 'md')
else
DevHid:del(Twix..'Hid:Lock:Fshar'..msg.chat_id_) DevHid:del(Twix..'Hid:Lock:Taf'..msg.chat_id_) DevHid:del(Twix..'Hid:Lock:Kfr'..msg.chat_id_) 
DevHid:set(Twix.."Hid:Lock:Bots"..msg.chat_id_,"del") DevHid:hset(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed") 
LockList ={'Hid:Lock:EditMsgs','Hid:Lock:Farsi','Hid:Lock:TagServr','Hid:Lock:Inline','Hid:Lock:Photo','Hid:Lock:Spam','Hid:Lock:Videos','Hid:Lock:Gifs','Hid:Lock:Music','Hid:Lock:Voice','Hid:Lock:Links','Hid:Lock:Location','Hid:Lock:Tags','Hid:Lock:Stickers','Hid:Lock:Markdown','Hid:Lock:Forwards','Hid:Lock:Document','Hid:Lock:Contact','Hid:Lock:Hashtak','Hid:Lock:WebLinks'}
for i,Lock in pairs(LockList) do
DevHid:set(Twix..Lock..msg.chat_id_,true)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم قفل جميع الاوامر")  
end
end
if text and text:match("^فتح الكل$") then
if not Constructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمنشئين فقط', 1, 'md')
else
DevHid:set(Twix..'Hid:Lock:Fshar'..msg.chat_id_,true) DevHid:set(Twix..'Hid:Lock:Taf'..msg.chat_id_,true) DevHid:set(Twix..'Hid:Lock:Kfr'..msg.chat_id_,true) DevHid:hdel(Twix.."Hid:Spam:Group:User"..msg.chat_id_ ,"Spam:User") 
UnLockList ={'Hid:Lock:EditMsgs','Hid:Lock:Text','Hid:Lock:Arabic','Hid:Lock:English','Hid:Lock:Join','Hid:Lock:Bots','Hid:Lock:Farsi','Hid:Lock:FarsiBan','Hid:Lock:TagServr','Hid:Lock:Inline','Hid:Lock:Photo','Hid:Lock:Spam','Hid:Lock:Videos','Hid:Lock:Gifs','Hid:Lock:Music','Hid:Lock:Voice','Hid:Lock:Links','Hid:Lock:Location','Hid:Lock:Tags','Hid:Lock:Stickers','Hid:Lock:Markdown','Hid:Lock:Forwards','Hid:Lock:Document','Hid:Lock:Contact','Hid:Lock:Hashtak','Hid:Lock:WebLinks'}
for i,UnLock in pairs(UnLockList) do
DevHid:del(Twix..UnLock..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم فتح جميع الاوامر")  
end
end
--     Source Twix     --
if Admin(msg) then
if text and (text:match("^ضع سبام (%d+)$") or text:match("^وضع سبام (%d+)$")) then
local SetSpam = text:match("ضع سبام (%d+)$") or text:match("وضع سبام (%d+)$")
if tonumber(SetSpam) < 40 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ اختر عدد اكبر من 40 حرف ', 1, 'md')
else
DevHid:set(Twix..'Hid:Spam:Text'..msg.chat_id_,SetSpam)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم وضع عدد السبام 𓄂'..SetSpam, 1, 'md')
end
end
end
--     Source Twix     --
if Manager(msg) then
if text == "فحص" or text == "فحص البوت" then
local Check = https.request('https://api.telegram.org/bot'..TokenBot..'/getChatMember?chat_id='..msg.chat_id_..'&user_id='..Twix)
local GetInfo = JSON.decode(Check)
if GetInfo.ok == true then
if GetInfo.result.can_change_info == true then EDT = '✔️' else EDT = '✖️' end
if GetInfo.result.can_delete_messages == true then DEL = '✔️' else DEL = '✖️' end
if GetInfo.result.can_invite_users == true then INV = '✔️' else INV = '✖️' end
if GetInfo.result.can_pin_messages == true then PIN = '✔️' else PIN = '✖️' end
if GetInfo.result.can_restrict_members == true then BAN = '✔️' else BAN = '✖️' end
if GetInfo.result.can_promote_members == true then VIP = '✔️' else VIP = '✖️' end 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ صلاحيات البوت هي 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ حذف الرسائل 𓄂 '..DEL..'\n⸙ ¦ دعوة المستخدمين 𓄂 '..INV..'\n⸙ ¦ حظر المستخدمين 𓄂 '..BAN..'\n⸙ ¦ تثبيت الرسائل 𓄂 '..PIN..'\n⸙ ¦ تغيير المعلومات 𓄂 '..EDT..'\n⸙ ¦ اضافة مشرفين 𓄂 '..VIP..'\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉', 1, 'md')
end end
if text and text:match("^تغير رد المطور (.*)$") then
local Text = text:match("^تغير رد المطور (.*)$") 
DevHid:set(Twix.."Hid:SudoBot:Rd"..msg.chat_id_,Text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد المطور الى 𓄂 "..Text, 1, 'md')
end
if text and text:match("^تغير رد منشئ الاساسي (.*)$") then
local Text = text:match("^تغير رد منشئ الاساسي (.*)$") 
DevHid:set(Twix.."Hid:BasicConstructor:Rd"..msg.chat_id_,Text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد المنشئ الاساسي الى 𓄂 "..Text, 1, 'md')
end
if text and text:match("^تغير رد المنشئ (.*)$") then
local Text = text:match("^تغير رد المنشئ (.*)$") 
DevHid:set(Twix.."Hid:Constructor:Rd"..msg.chat_id_,Text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد المنشئ الى 𓄂 "..Text, 1, 'md')
end
if text and text:match("^تغير رد المدير (.*)$") then
local Text = text:match("^تغير رد المدير (.*)$") 
DevHid:set(Twix.."Hid:Managers:Rd"..msg.chat_id_,Text) 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد المدير الى 𓄂 "..Text, 1, 'md')
end
if text and text:match("^تغير رد الادمن (.*)$") then
local Text = text:match("^تغير رد الادمن (.*)$") 
DevHid:set(Twix.."Hid:Admins:Rd"..msg.chat_id_,Text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد الادمن الى 𓄂 "..Text, 1, 'md')
end
if text and text:match("^تغير رد المميز (.*)$") then
local Text = text:match("^تغير رد المميز (.*)$") 
DevHid:set(Twix.."Hid:VipMem:Rd"..msg.chat_id_,Text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد المميز الى 𓄂 "..Text, 1, 'md')
end
if text and text:match("^تغير رد المنظف (.*)$") then
local Text = text:match("^تغير رد المنظف (.*)$") 
DevHid:set(Twix.."Hid:Cleaner:Rd"..msg.chat_id_,Text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد المنظف الى 𓄂 "..Text, 1, 'md')
end
if text and text:match("^تغير رد العضو (.*)$") then
local Text = text:match("^تغير رد العضو (.*)$") 
DevHid:set(Twix.."Hid:mem:Rd"..msg.chat_id_,Text)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تغير رد العضو الى 𓄂 "..Text, 1, 'md')
end
if text == "حذف ردود الرتب" or text == "مسح ردود الرتب" then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف جميع ردود الرتب", 1, 'md')
DevHid:del(Twix.."Hid:mem:Rd"..msg.chat_id_)
DevHid:del(Twix.."Hid:Cleaner:Rd"..msg.chat_id_)
DevHid:del(Twix.."Hid:VipMem:Rd"..msg.chat_id_)
DevHid:del(Twix.."Hid:Admins:Rd"..msg.chat_id_)
DevHid:del(Twix.."Hid:Managers:Rd"..msg.chat_id_)
DevHid:del(Twix.."Hid:Constructor:Rd"..msg.chat_id_)
DevHid:del(Twix.."Hid:BasicConstructor:Rd"..msg.chat_id_)
DevHid:del(Twix.."Hid:SudoBot:Rd"..msg.chat_id_)
end
end
--     Source Twix     --
if text == "كشف البوتات" and ChCheck(msg) then 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(extra,result,success)
local admins = result.members_  
text = '⸙ ¦ *قائمة البوتات* 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
local n = 0
local t = 0
for i=0 , #admins do 
n = (n + 1)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_
},function(arg,data) 
if result.members_[i].status_.ID == "ChatMemberStatusMember" then  
ab = ''
elseif result.members_[i].status_.ID == "ChatMemberStatusEditor" then  
t = t + 1
ab = ' ✯'
end
text = text.."~ [@"..data.username_..']'..ab.."\n"
if #admins == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتوجد بوتات هنا*", 1, 'md')
return false end
if #admins == i then 
local a = '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ *عدد البوتات هنا* 𓄂 '..n..'\n'
local f = '⸙ ¦ *عدد البوتات المرفوعه* 𓄂 '..t..'\n⸙ ¦ *ملاحضه علامة الـ*✯ *تعني ان البوت ادمن في هذه المجموعه*'
Dev_Hid(msg.chat_id_, msg.id_, 1, text..a..f, 1, 'md')
end
end,nil)
end
end,nil)
end
if text == 'حذف البوتات' and ChCheck(msg) or text == 'طرد البوتات' and ChCheck(msg) or text == 'مسح البوتات' and ChCheck(msg) then
tdcli_function ({ ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,dp)  
local admins = dp.members_  
local x = 0
local c = 0
for i=0 , #admins do 
if dp.members_[i].status_.ID == "ChatMemberStatusEditor" then  
x = x + 1 
end
if tonumber(admins[i].user_id_) ~= tonumber(Twix) then
ChatKick(msg.chat_id_,admins[i].user_id_)
end
c = c + 1
end     
if (c - x) == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *لاتوجد بوتات هنا*", 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ *عدد البوتات هنا* 𓄂 "..c.."\n⸙ ¦ *عدد البوتات المرفوعه* 𓄂 "..x.."\n⸙ ¦ *تم طرد* 𓄂 "..(c - x).." *من البوتات*", 1, 'md')
end 
end,nil)  
end 
--     Source Twix     --
end
--     Source Twix     --
if Admin(msg) then
if text and text:match("^حذف (.*)$") or text and text:match("^مسح (.*)$") then
local txts = {string.match(text, "^(حذف) (.*)$")}
local txtss = {string.match(text, "^(مسح) (.*)$")}
if Sudo(msg) then 
if txts[2] == 'الثانويين' or txtss[2] == 'الثانويين' or txts[2] == 'المطورين الثانويين' or txtss[2] == 'المطورين الثانويين' then
DevHid:del(Twix..'Hid:SecondSudo:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المطورين الثانويين")  
end
end
if SecondSudo(msg) then 
if txts[2] == 'المطورين' or txtss[2] == 'المطورين' then
DevHid:del(Twix..'Hid:SudoBot:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المطورين")  
end
if txts[2] == 'قائمه العام' or txtss[2] == 'قائمه العام' then
DevHid:del(Twix..'Hid:BanAll:')
DevHid:del(Twix..'Hid:MuteAll:')
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف قائمة العام")  
end
end
if SudoBot(msg) then
if txts[2] == 'الادمنيه العامين' or txts[2] == 'الادمنيه العام' or txtss[2] == 'الادمنيه العامين' or txtss[2] == 'الادمنيه العام' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف الادمنيه العامين")  
DevHid:del(Twix..'Hid:AdminAll:')
end
if txts[2] == 'المميزين عام' or txts[2] == 'المميزين العامين' or txtss[2] == 'المميزين عام' or txtss[2] == 'المميزين العامين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المميزين عام")  
DevHid:del(Twix..'Hid:VipAll:')
end
if txts[2] == 'المدراء العامين' or txts[2] == 'المدراء العام' or txtss[2] == 'المدراء العامين' or txtss[2] == 'المدراء العام' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المدراء العامين")  
DevHid:del(Twix..'Hid:ManagerAll:')
end
end
if HidConstructor(msg) then
if txts[2] == 'المنشئين الاساسيين' or txtss[2] == 'المنشئين الاساسيين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المنشئين الاساسيين")  
DevHid:del(Twix..'Hid:BasicConstructor:'..msg.chat_id_)
end
end
if BasicConstructor(msg) then
if txts[2] == 'المنشئين' or txtss[2] == 'المنشئين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المنشئين")  
DevHid:del(Twix..'Hid:Constructor:'..msg.chat_id_)
end end
if Constructor(msg) then
if txts[2] == 'المدراء' or txtss[2] == 'المدراء' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المدراء")  
DevHid:del(Twix..'Hid:Managers:'..msg.chat_id_)
end 
if txts[2] == 'المنظفين' or txtss[2] == 'المنظفين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المنظفين")  
DevHid:del(Twix..'Hid:Cleaner:'..msg.chat_id_)
end end
if Manager(msg) then
if txts[2] == 'الادمنيه' or txtss[2] == 'الادمنيه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف الادمنيه")  
DevHid:del(Twix..'Hid:Admins:'..msg.chat_id_)
end
end
if txts[2] == 'المطايه' or txtss[2] == 'المطايه' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المطايه")  
DevHid:del(Twix..'User:Donky:'..msg.chat_id_)
end
if txts[2] == 'الرابط' or txtss[2] == 'الرابط' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف رابط المجموعه")  
DevHid:del(Twix.."Hid:Groups:Links"..msg.chat_id_)
end
if txts[2] == 'المميزين' or txtss[2] == 'المميزين' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المميزين")  
DevHid:del(Twix..'Hid:VipMem:'..msg.chat_id_)
end
if txts[2] == 'المكتومين' or txtss[2] == 'المكتومين' then
DevHid:del(Twix..'Hid:Muted:'..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المكتومين")  
end
if txts[2] == 'المقيدين' or txtss[2] == 'المقيدين' then     
local List = DevHid:smembers(Twix..'Hid:Tkeed:'..msg.chat_id_)
for k,v in pairs(List) do   
HTTPS.request("https://api.telegram.org/bot"..TokenBot.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..v.."&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True") 
DevHid:srem(Twix..'Hid:Tkeed:'..msg.chat_id_, v)
end 
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المقيدين")  
end
if txts[2] == 'قائمه المنع' or txtss[2] == 'قائمه المنع' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف قائمة المنع")  
DevHid:del(Twix..'Hid:Filters:'..msg.chat_id_)
end
if txts[2] == 'قوائم المنع' or txtss[2] == 'قوائم المنع' then
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف قوائم المنع")  
DevHid:del(Twix..'Hid:Filters:'..msg.chat_id_)
DevHid:del(Twix.."Hid:FilterAnimation"..msg.chat_id_)
DevHid:del(Twix.."Hid:FilterPhoto"..msg.chat_id_)
DevHid:del(Twix.."Hid:FilterSteckr"..msg.chat_id_)
end
if txts[2] == 'قائمه منع المتحركات' or txtss[2] == 'قائمه منع المتحركات' then     
DevHid:del(Twix.."Hid:FilterAnimation"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف قائمة منع المتحركات")  
end
if txts[2] == 'قائمه منع الصور' or txtss[2] == 'قائمه منع الصور' then     
DevHid:del(Twix.."Hid:FilterPhoto"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف قائمة منع الصور")  
end
if txts[2] == 'قائمه منع الملصقات' or txtss[2] == 'قائمه منع الملصقات' then     
DevHid:del(Twix.."Hid:FilterSteckr"..msg.chat_id_)
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف قائمة منع الملصقات")  
end
end
end
--     Source Twix     --
if text and text:match("^حذف القوائم$") and ChCheck(msg) or text and text:match("^مسح القوائم$") and ChCheck(msg) then
if not BasicConstructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمنشئ الاساسي فقط', 1, 'md')
else
DevHid:del(Twix..'Hid:Ban:'..msg.chat_id_) DevHid:del(Twix..'Hid:Admins:'..msg.chat_id_) DevHid:del(Twix..'User:Donky:'..msg.chat_id_) DevHid:del(Twix..'Hid:VipMem:'..msg.chat_id_) DevHid:del(Twix..'Hid:Filters:'..msg.chat_id_) DevHid:del(Twix..'Hid:Muted:'..msg.chat_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف 𓄂 ❨ قائمة المنع • المحظورين • المكتومين • الادمنيه • المميزين • المطايه ❩ بنجاح \n ✓", 1, 'md')
end end
--     Source Twix     --
if text and text:match("^حذف جميع الرتب$") and ChCheck(msg) or text and text:match("^مسح جميع الرتب$") and ChCheck(msg) or text and text:match("^تنزيل جميع الرتب$") and ChCheck(msg) then
if not HidConstructor(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لمنشئ المجموعه فقط', 1, 'md')
else
local basicconstructor = DevHid:smembers(Twix..'Hid:BasicConstructor:'..msg.chat_id_)
local constructor = DevHid:smembers(Twix..'Hid:Constructor:'..msg.chat_id_)
local Managers = DevHid:smembers(Twix..'Hid:Managers:'..msg.chat_id_)
local admins = DevHid:smembers(Twix..'Hid:Admins:'..msg.chat_id_)
local vipmem = DevHid:smembers(Twix..'Hid:VipMem:'..msg.chat_id_)
local donky = DevHid:smembers(Twix..'User:Donky:'..msg.chat_id_)
if #basicconstructor ~= 0 then basicconstructort = 'المنشئين الاساسيين • ' else basicconstructort = '' end
if #constructor ~= 0 then constructort = 'المنشئين • ' else constructort = '' end
if #Managers ~= 0 then Managerst = 'المدراء • ' else Managerst = '' end
if #admins ~= 0 then adminst = 'الادمنيه • ' else adminst = '' end
if #vipmem ~= 0 then vipmemt = 'المميزين • ' else vipmemt = '' end
if #donky ~= 0 then donkyt = 'المطايه • ' else donkyt = '' end
if #basicconstructor ~= 0 or #constructor ~= 0 or #Managers ~= 0 or #admins ~= 0 or #vipmem ~= 0 or #donky ~= 0 then 
DevHid:del(Twix..'Hid:BasicConstructor:'..msg.chat_id_)
DevHid:del(Twix..'Hid:Constructor:'..msg.chat_id_)
DevHid:del(Twix..'Hid:Managers:'..msg.chat_id_)
DevHid:del(Twix..'Hid:Admins:'..msg.chat_id_)
DevHid:del(Twix..'Hid:VipMem:'..msg.chat_id_)
DevHid:del(Twix..'User:Donky:'..msg.chat_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف جميع الرتب التاليه 𓄂 ❨ "..basicconstructort..''..constructort..''..Managerst..''..adminst..''..vipmemt..''..donkyt.." ❩ بنجاح \n ✓", 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لاتوجد رتب هنا", 1, 'md')
end 
end 
end
--     Source Twix     --
if Admin(msg) then 
if text and text:match("^الاعدادات$") and ChCheck(msg) then
if not DevHid:get(Twix..'Hid:Spam:Text'..msg.chat_id_) then
spam_c = 400
else
spam_c = DevHid:get(Twix..'Hid:Spam:Text'..msg.chat_id_)
end
--     Source Twix     --
if DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_, "Spam:User") == "kick" then     
flood = "بالطرد"     
elseif DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Spam:User") == "keed" then     
flood = "بالتقيد"     
elseif DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Spam:User") == "mute" then     
flood = "بالكتم"           
elseif DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Spam:User") == "del" then     
flood = "بالحذف"
else     
flood = "مفتوح"     
end
--     Source Twix     --
if DevHid:get(Twix.."Hid:Lock:Bots"..msg.chat_id_) == "del" then
lock_bots = "بالحذف"
elseif DevHid:get(Twix.."Hid:Lock:Bots"..msg.chat_id_) == "ked" then
lock_bots = "بالتقيد"   
elseif DevHid:get(Twix.."Hid:Lock:Bots"..msg.chat_id_) == "kick" then
lock_bots = "بالطرد"    
else
lock_bots = "مفتوحه"    
end
--     Source Twix     --
if DevHid:get(Twix..'Hid:Lock:Text'..msg.chat_id_) then mute_text = 'مقفله' else mute_text = 'مفتوحه'end
if DevHid:get(Twix..'Hid:Lock:Photo'..msg.chat_id_) then mute_photo = 'مقفله' else mute_photo = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Videos'..msg.chat_id_) then mute_video = 'مقفله' else mute_video = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Gifs'..msg.chat_id_) then mute_gifs = 'مقفله' else mute_gifs = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Music'..msg.chat_id_) then mute_music = 'مقفله' else mute_music = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Inline'..msg.chat_id_) then mute_in = 'مقفله' else mute_in = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Voice'..msg.chat_id_) then mute_voice = 'مقفله' else mute_voice = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) then mute_edit = 'مقفله' else mute_edit = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then mute_links = 'مقفله' else mute_links = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Pin'..msg.chat_id_) then lock_pin = 'مقفله' else lock_pin = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Stickers'..msg.chat_id_) then lock_sticker = 'مقفله' else lock_sticker = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:TagServr'..msg.chat_id_) then lock_tgservice = 'مقفله' else lock_tgservice = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then lock_wp = 'مقفله' else lock_wp = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then lock_htag = 'مقفله' else lock_htag = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then lock_tag = 'مقفله' else lock_tag = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Location'..msg.chat_id_) then lock_location = 'مقفله' else lock_location = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Contact'..msg.chat_id_) then lock_contact = 'مقفله' else lock_contact = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then lock_english = 'مقفله' else lock_english = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then lock_arabic = 'مقفله' else lock_arabic = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then lock_forward = 'مقفله' else lock_forward = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Document'..msg.chat_id_) then lock_file = 'مقفله' else lock_file = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Markdown'..msg.chat_id_) then markdown = 'مقفله' else markdown = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Spam'..msg.chat_id_) then lock_spam = 'مقفله' else lock_spam = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Join'..msg.chat_id_) then lock_Join = 'مقفل' else lock_Join = 'مفتوح' end
if DevHid:get(Twix.."Hid:Lock:Welcome"..msg.chat_id_) then send_welcome = 'مقفله' else send_welcome = 'مفتوحه' end
if DevHid:get(Twix..'Hid:Lock:Fshar'..msg.chat_id_) then lock_fshar = 'مفتوح' else lock_fshar = 'مقفل' end
if DevHid:get(Twix..'Hid:Lock:Kfr'..msg.chat_id_) then lock_kaf = 'مفتوح' else lock_kaf = 'مقفل' end
if DevHid:get(Twix..'Hid:Lock:Taf'..msg.chat_id_) then lock_taf = 'مفتوحه' else lock_taf = 'مقفله' end
if DevHid:get(Twix..'Hid:Lock:Farsi'..msg.chat_id_) then lock_farsi = 'مقفله' else lock_farsi = 'مفتوحه' end
local Flood_Num = DevHid:hget(Twix.."Hid:Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5
--     Source Twix     --
local TXTE = "⸙ ¦ اعدادات المجموعه 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
.."⸙ ¦ الروابط 𓄂 "..mute_links.."\n"
.."⸙ ¦ المعرف 𓄂 "..lock_tag.."\n"
.."⸙ ¦ البوتات 𓄂 "..lock_bots.."\n"
.."⸙ ¦ المتحركه 𓄂 "..mute_gifs.."\n"
.."⸙ ¦ الملصقات 𓄂 "..lock_sticker.."\n"
.."⸙ ¦ الملفات 𓄂 "..lock_file.."\n"
.."⸙ ¦ الصور 𓄂 "..mute_photo.."\n"
.."⸙ ¦ الفيديو 𓄂 "..mute_video.."\n"
.."⸙ ¦ الاونلاين 𓄂 "..mute_in.."\n"
.."⸙ ¦ الدردشه 𓄂 "..mute_text.."\n"
.."⸙ ¦ التوجيه 𓄂 "..lock_forward.."\n"
.."⸙ ¦ الاغاني 𓄂 "..mute_music.."\n"
.."⸙ ¦ الصوت 𓄂 "..mute_voice.."\n"
.."⸙ ¦ الجهات 𓄂 "..lock_contact.."\n"
.."⸙ ¦ الماركداون 𓄂 "..markdown.."\n"
.."⸙ ¦ الهاشتاك 𓄂 "..lock_htag.."\n"
.."⸙ ¦ التعديل 𓄂 "..mute_edit.."\n"
.."⸙ ¦ التثبيت 𓄂 "..lock_pin.."\n"
.."⸙ ¦ الاشعارات 𓄂 "..lock_tgservice.."\n"
.."⸙ ¦ الكلايش 𓄂 "..lock_spam.."\n"
.."⸙ ¦ الدخول 𓄂 "..lock_Join.."\n"
.."⸙ ¦ الشبكات 𓄂 "..lock_wp.."\n"
.."⸙ ¦ المواقع 𓄂 "..lock_location.."\n"
.."⸙ ¦ الفشار 𓄂 "..lock_fshar.."\n"
.."⸙ ¦ الكفر 𓄂 "..lock_kaf.."\n"
.."⸙ ¦ الطائفيه 𓄂 "..lock_taf.."\n"
.."⸙ ¦ العربيه 𓄂 "..lock_arabic.."\n"
.."⸙ ¦ الانكليزيه 𓄂 "..lock_english.."\n"
.."⸙ ¦ الفارسيه 𓄂 "..lock_farsi.."\n"
.."⸙ ¦ التكرار 𓄂 "..flood.."\n"
.."⸙ ¦ عدد التكرار 𓄂 "..Flood_Num.."\n"
.."⸙ ¦ عدد السبام 𓄂 "..spam_c.."\n"
.."┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ [Source Channel](https://t.me/x_xxax)\n"
Dev_Hid(msg.chat_id_, msg.id_, 1, TXTE, 1, 'md')
end
end
--     Source Twix     --
if text and text:match("^كول (.*)$") then
local txt = {string.match(text, "^(كول) (.*)$")}
Dev_Hid(msg.chat_id_,0, 1, txt[2], 1, 'md')
DeleteMessage(msg.chat_id_,{[0] = msg.id_})
end
if text and text:match("^انطق (.*)$") then
local UrlAntk = https.request('https://apiHid.ml/Antk.php?Hid='..URL.escape(text:match("^انطق (.*)$")))
Antk = JSON.decode(UrlAntk)
if UrlAntk.ok ~= false then
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '⸙ Twix TeAM .',url="t.me/x_xxax"}},
}
local msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendAudio?chat_id='..msg.chat_id_..'&audio='..URL.escape(Antk.result.link).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
--     Source Twix     --
if DevHid:get(Twix..'Hid:setrules'..msg.chat_id_..':'..msg.sender_user_id_) then 
if text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء حفظ قوانين المجموعه', 1, 'md')
DevHid:del(Twix..'Hid:setrules'..msg.chat_id_..':'..msg.sender_user_id_)
return false  
end 
DevHid:del(Twix..'Hid:setrules'..msg.chat_id_..':'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:rules'..msg.chat_id_,text)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حفظ قوانين المجموعه', 1, 'md')
return false   
end
if text and text:match("^ضع قوانين$") and ChCheck(msg) or text and text:match("^وضع قوانين$") and ChCheck(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل لي القوانين الان', 1, 'md')
DevHid:set(Twix..'Hid:setrules'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
end
if text and text:match("^القوانين$") then
local rules = DevHid:get(Twix..'Hid:rules'..msg.chat_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, rules, 1, nil)
end
--     Source Twix     --
if text == 'رقمي' then
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(extra,result,success)
if result.phone_number_  then
MyNumber = "⸙ ¦ رقمك 𓄂 +"..result.phone_number_
else
MyNumber = "⸙ ¦ تم وضع رقمك لجهات اتصالك فقط"
end
send(msg.chat_id_, msg.id_,MyNumber)
end,nil)
end
--     Source Twix     --
if text == "تفعيل الزخرفه" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الزخرفه بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Zrf:Hid'..msg.chat_id_) 
end
if text == "تعطيل الزخرفه" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الزخرفه بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Zrf:Hid'..msg.chat_id_,true)  
end
if DevHid:get(Twix..'Zrf:Hid'..msg.chat_id_..''..msg.sender_user_id_) then 
if text and text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر الزخرفه', 1, 'md')
DevHid:del(Twix..'Zrf:Hid'..msg.chat_id_..''..msg.sender_user_id_)
return false  
end 
UrlZrf = https.request('https://apiHid.ml/zrf.php?Hid='..URL.escape(text)) 
Zrf = JSON.decode(UrlZrf) 
t = "⸙ ¦ قائمة الزخرفه 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k,v in pairs(Zrf.ok) do
i = i + 1
t = t..i.."~ `"..v.."` \n"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, t, 1, 'md')
DevHid:del(Twix..'Zrf:Hid'..msg.chat_id_..''..msg.sender_user_id_)
return false   
end
if not DevHid:get(Twix..'Hid:Zrf:Hid'..msg.chat_id_) then
if text == 'زخرفه' and ChCheck(msg) or text == 'الزخرفه' and ChCheck(msg) then  
DevHid:setex(Twix.."Zrf:Hid"..msg.chat_id_..""..msg.sender_user_id_,300,true)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل لي الكلمه لزخرفتها \nيمكنك الزخرفة باللغه { en } ~ { ar } ', 1, 'md')
end
end
if not DevHid:get(Twix..'Hid:Zrf:Hid'..msg.chat_id_) then
if text and text:match("^زخرفه (.*)$") and ChCheck(msg) or text and text:match("^زخرف (.*)$") and ChCheck(msg) then 
local TextZrf = text:match("^زخرفه (.*)$") or text:match("^زخرف (.*)$") 
UrlZrf = https.request('https://apiHid.ml/zrf.php?Hid='..URL.escape(TextZrf)) 
Zrf = JSON.decode(UrlZrf) 
t = "⸙ ¦ قائمة الزخرفه 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
i = 0
for k,v in pairs(Zrf.ok) do
i = i + 1
t = t..i.."~ `"..v.."` \n"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, t, 1, 'md')
end
end
--     Source Twix     --
if text == "تفعيل الابراج" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الابراج بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Brg:Hid'..msg.chat_id_) 
end
if text == "تعطيل الابراج" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الابراج بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Brg:Hid'..msg.chat_id_,true)  
end
if not DevHid:get(Twix..'Hid:Brg:Hid'..msg.chat_id_) then
if text and text:match("^برج (.*)$") and ChCheck(msg) or text and text:match("^برجي (.*)$") and ChCheck(msg) then 
local TextBrg = text:match("^برج (.*)$") or text:match("^برجي (.*)$") 
UrlBrg = https.request('https://apiHid.ml/brg.php?brg='..URL.escape(TextBrg)) 
Brg = JSON.decode(UrlBrg) 
t = Brg.ok.Hid  
Dev_Hid(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end
--     Source Twix     --
if text and (text == "تفعيل اوامر النسب" or text == "تفعيل نسبه الحب" or text == "تفعيل نسبه الكره" or text == "تفعيل نسبه الرجوله" or text == "تفعيل نسبه الانوثه" or text == "تفعيل نسبه الغباء") and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل اوامر النسب'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Nsba:Hid'..msg.chat_id_) 
end
if text and (text == "تعطيل اوامر النسب" or text == "تعطيل نسبه الحب" or text == "تعطيل نسبه الكره" or text == "تعطيل نسبه الرجوله" or text == "تعطيل نسبه الانوثه" or text == "تعطيل نسبه الغباء") and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل اوامر النسب'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Nsba:Hid'..msg.chat_id_,true)  
end
if not DevHid:get(Twix..'Hid:Nsba:Hid'..msg.chat_id_) then
if text == "نسبه الحب" and ChCheck(msg) or text == "نسبة الحب" and ChCheck(msg) then
DevHid:set(Twix..'LoveNsba:Hid'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ قم بارسل اسمين لحساب نسبة الحب بينهما كمثال 𓄂 جاك وروز', 1, 'md')
end
end
if text and text ~= "نسبه الحب" and text ~= "نسبة الحب" and DevHid:get(Twix..'LoveNsba:Hid'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر نسبة الحب ', 1, 'md')
DevHid:del(Twix..'LoveNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Hid = math.random(0,100);
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ نسبة الحب بين '..text..' هي : '..Hid..'%', 1, 'md')
DevHid:del(Twix..'LoveNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevHid:get(Twix..'Hid:Nsba:Hid'..msg.chat_id_) then
if text == "نسبه الكره" and ChCheck(msg) or text == "نسبة الكره" and ChCheck(msg) then
DevHid:set(Twix..'HataNsba:Hid'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ قم بارسل اسمين لحساب نسبة الكره بينهما كمثال 𓄂 جاك وروز', 1, 'md')
end
end
if text and text ~= "نسبه الكره" and text ~= "نسبة الكره" and DevHid:get(Twix..'HataNsba:Hid'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر نسبة الكره ', 1, 'md')
DevHid:del(Twix..'HataNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Hid = math.random(0,100);
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ نسبة الكره بين '..text..' هي : '..Hid..'%', 1, 'md')
DevHid:del(Twix..'HataNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevHid:get(Twix..'Hid:Nsba:Hid'..msg.chat_id_) then
if text and (text == "نسبه الرجوله" or text == "نسبة الرجوله" or text == "نسبه رجوله" or text == "نسبة رجوله") and ChCheck(msg) then
DevHid:set(Twix..'RjolaNsba:Hid'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ قم بارسل اسم الشخص لقياس نسبة رجولته كمثال 𓄂 جاك', 1, 'md')
end
end
if text and text ~= "نسبه الرجوله" and text ~= "نسبة الرجوله" and text ~= "نسبه رجوله" and text ~= "نسبة رجوله" and DevHid:get(Twix..'RjolaNsba:Hid'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر نسبة الرجوله ', 1, 'md')
DevHid:del(Twix..'RjolaNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Hid = math.random(0,100);
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ نسبة رجولة '..text..' هي : '..Hid..'%', 1, 'md')
DevHid:del(Twix..'RjolaNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevHid:get(Twix..'Hid:Nsba:Hid'..msg.chat_id_) then
if text and (text == "نسبه الانوثه" or text == "نسبة الانوثه" or text == "نسبه انوثه" or text == "نسبة انوثه") and ChCheck(msg) then
DevHid:set(Twix..'AnothaNsba:Hid'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ قم بارسل اسم الشخص لقياس نسبة انوثته كمثال 𓄂 روز', 1, 'md')
end
end
if text and text ~= "نسبه الانوثه" and text ~= "نسبة الانوثه" and text ~= "نسبه انوثه" and text ~= "نسبة انوثه" and DevHid:get(Twix..'AnothaNsba:Hid'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر نسبة الانوثه ', 1, 'md')
DevHid:del(Twix..'AnothaNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Hid = math.random(0,100);
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ نسبة انوثة '..text..' هي : '..Hid..'%', 1, 'md')
DevHid:del(Twix..'AnothaNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
if not DevHid:get(Twix..'Hid:Nsba:Hid'..msg.chat_id_) then
if text and (text == "نسبه الغباء" or text == "نسبة الغباء") and ChCheck(msg) then
DevHid:set(Twix..'StupidNsba:Hid'..msg.chat_id_..msg.sender_user_id_,true) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ قم بارسل اسم الشخص لقياس نسبة غبائه كمثال 𓄂 جاك او روز', 1, 'md')
end
end
if text and text ~= "نسبه الغباء" and text ~= "نسبة الغباء" and DevHid:get(Twix..'StupidNsba:Hid'..msg.chat_id_..msg.sender_user_id_) then
if text and text == 'الغاء' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم الغاء امر نسبة الغباء ', 1, 'md')
DevHid:del(Twix..'StupidNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end 
Hid = math.random(0,100);
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ نسبة غباء '..text..' هي : '..Hid..'%', 1, 'md')
DevHid:del(Twix..'StupidNsba:Hid'..msg.chat_id_..msg.sender_user_id_) 
return false 
end
--     Source Twix     --
if text == "تفعيل حساب العمر" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل حساب العمر'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Age:Hid'..msg.chat_id_) 
end
if text == "تعطيل حساب العمر" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل حساب العمر'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Age:Hid'..msg.chat_id_,true)  
end
if not DevHid:get(Twix..'Hid:Age:Hid'..msg.chat_id_) then
if text and text:match("^احسب (.*)$") and ChCheck(msg) or text and text:match("^عمري (.*)$") and ChCheck(msg) then 
local TextAge = text:match("^احسب (.*)$") or text:match("^عمري (.*)$") 
UrlAge = https.request('https://apiHid.ml/age.php?age='..URL.escape(TextAge)) 
Age = JSON.decode(UrlAge) 
t = Age.ok.Hid
Dev_Hid(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end
--     Source Twix     --
if text == "تفعيل معاني الاسماء" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل معاني الاسماء'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Mean:Hid'..msg.chat_id_) 
end
if text == "تعطيل معاني الاسماء" and Manager(msg) and ChCheck(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل معاني الاسماء'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Mean:Hid'..msg.chat_id_,true)  
end
if not DevHid:get(Twix..'Hid:Mean:Hid'..msg.chat_id_) then
if text and text:match("^معنى الاسم (.*)$") and ChCheck(msg) or text and text:match("^معنى اسم (.*)$") and ChCheck(msg) then 
local TextMean = text:match("^معنى الاسم (.*)$") or text:match("^معنى اسم (.*)$") 
UrlMean = https.request('https://apiHid.ml/Mean.php?Hid='..URL.escape(TextMean)) 
Mean = JSON.decode(UrlMean) 
t = Mean.ok.Hid
Dev_Hid(msg.chat_id_, msg.id_, 1, t, 1, 'html')
end
end
--     Source Twix     --
if text == "غنيلي" and ChCheck(msg) then
data,res = https.request('https://apiabs.ml/Audios.php')
if res == 200 then
Audios = json:decode(data)
if Audios.Info == true then
local Text ='⌁︙تم اختيار المقطع الصوتي لك'
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '⸙ ¦ Twix TEAM .',url="t.me/x_xxax"}},
}
local msg_id = msg.id_/2097152/0.5
https.request("https://api.telegram.org/bot"..TokenBot..'/sendVoice?chat_id=' .. msg.chat_id_ .. '&voice='..URL.escape(Audios.info)..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
end
--     Source Twix     --
if Admin(msg) then
if DevHid:get(Twix..'Hid:LockSettings'..msg.chat_id_) then 
if text == "الروابط" then if DevHid:get(Twix..'Hid:Lock:Links'..msg.chat_id_) then mute_links = 'مقفله' else mute_links = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الروابط 𓄂 "..mute_links.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "المعرف" or text == "المعرفات" then if DevHid:get(Twix..'Hid:Lock:Tags'..msg.chat_id_) then lock_tag = 'مقفوله' else lock_tag = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ المعرف 𓄂 "..lock_tag.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "المتحركه" or text == "الملصقات المتحركه" then if DevHid:get(Twix..'Hid:Lock:Gifs'..msg.chat_id_) then mute_gifs = 'مقفوله' else mute_gifs = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ المتحركه 𓄂 "..mute_gifs.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الملصقات" then if DevHid:get(Twix..'Hid:Lock:Stickers'..msg.chat_id_) then lock_sticker = 'مقفوله' else lock_sticker = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الملصقات 𓄂 "..lock_sticker.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الصور" then if DevHid:get(Twix..'Hid:Lock:Photo'..msg.chat_id_) then mute_photo = 'مقفوله' else mute_photo = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الصور 𓄂 "..mute_photo.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الفيديو" or text == "الفيديوهات" then if DevHid:get(Twix..'Hid:Lock:Videos'..msg.chat_id_) then mute_video = 'مقفوله' else mute_video = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الفيديو 𓄂 "..mute_video.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الاونلاين" then if DevHid:get(Twix..'Hid:Lock:Inline'..msg.chat_id_) then mute_in = 'مقفل' else mute_in = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ الاونلاين 𓄂 "..mute_in.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الدردشه" then if DevHid:get(Twix..'Hid:Lock:Text'..msg.chat_id_) then mute_text = 'مقفله' else mute_text = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الدردشه 𓄂 "..mute_text.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "التوجيه" or text == "اعاده التوجيه" then if DevHid:get(Twix..'Hid:Lock:Forwards'..msg.chat_id_) then lock_forward = 'مقفل' else lock_forward = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ التوجيه 𓄂 "..lock_forward.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الاغاني" then if DevHid:get(Twix..'Hid:Lock:Music'..msg.chat_id_) then mute_music = 'مقفوله' else mute_music = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الاغاني 𓄂 "..mute_music.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الصوت" or text == "الصوتيات" then if DevHid:get(Twix..'Hid:Lock:Voice'..msg.chat_id_) then mute_voice = 'مقفول' else mute_voice = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ الصوت 𓄂 "..mute_voice.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الجهات" or text == "جهات الاتصال" then if DevHid:get(Twix..'Hid:Lock:Contact'..msg.chat_id_) then lock_contact = 'مقفوله' else lock_contact = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الجهات 𓄂 "..lock_contact.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الماركداون" then if DevHid:get(Twix..'Hid:Lock:Markdown'..msg.chat_id_) then markdown = 'مقفل' else markdown = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ الماركداون 𓄂 "..markdown.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الهاشتاك" then if DevHid:get(Twix..'Hid:Lock:Hashtak'..msg.chat_id_) then lock_htag = 'مقفل' else lock_htag = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ الهاشتاك 𓄂 "..lock_htag.."\n"Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "التعديل" then if DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) then mute_edit = 'مقفل' else mute_edit = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ التعديل 𓄂 "..mute_edit.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "التثبيت" then if DevHid:get(Twix..'Hid:Lock:Pin'..msg.chat_id_) then lock_pin = 'مقفل' else lock_pin = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ التثبيت 𓄂 "..lock_pin.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الاشعارات" then if DevHid:get(Twix..'Hid:Lock:TagServr'..msg.chat_id_) then lock_tgservice = 'مقفوله' else lock_tgservice = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الاشعارات 𓄂 "..lock_tgservice.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الكلايش" then if DevHid:get(Twix..'Hid:Lock:Spam'..msg.chat_id_) then lock_spam = 'مقفوله' else lock_spam = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الكلايش 𓄂 "..lock_spam.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الدخول" then if DevHid:get(Twix..'Hid:Lock:Join'..msg.chat_id_) then lock_Join = 'مقفول' else lock_Join = 'مفتوح' end local HidTwixTEAM = "\n" .."⸙ ¦ الدخول 𓄂 "..lock_Join.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الشبكات" then if DevHid:get(Twix..'Hid:Lock:WebLinks'..msg.chat_id_) then lock_wp = 'مقفوله' else lock_wp = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الشبكات 𓄂 "..lock_wp.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "المواقع" then if DevHid:get(Twix..'Hid:Lock:Location'..msg.chat_id_) then lock_location = 'مقفوله' else lock_location = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ المواقع 𓄂 "..lock_location.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "العربيه" then if DevHid:get(Twix..'Hid:Lock:Arabic'..msg.chat_id_) then lock_arabic = 'مقفوله' else lock_arabic = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ العربيه 𓄂 "..lock_arabic.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الانكليزيه" then if DevHid:get(Twix..'Hid:Lock:English'..msg.chat_id_) then lock_english = 'مقفوله' else lock_english = 'مفتوحه' end local HidTwixTEAM = "\n" .."⸙ ¦ الانكليزيه 𓄂 "..lock_english.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الكفر" then if DevHid:get(Twix..'Hid:Lock:Kfr'..msg.chat_id_) then lock_kaf = 'مفتوح' else lock_kaf = 'مقفل' end local HidTwixTEAM = "\n" .."⸙ ¦ الكفر 𓄂 "..lock_kaf.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الفشار" then if DevHid:get(Twix..'Hid:Lock:Fshar'..msg.chat_id_) then lock_fshar = 'مفتوح' else lock_fshar = 'مقفل' end local HidTwixTEAM = "\n" .."⸙ ¦ الفشار 𓄂 "..lock_fshar.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
if text == "الطائفيه" then if DevHid:get(Twix..'Hid:Lock:Taf'..msg.chat_id_) then lock_taf = 'مفتوحه' else lock_taf = 'مقفله' end local HidTwixTEAM = "\n" .."⸙ ¦ الطائفيه 𓄂 "..lock_taf.."\n" Dev_Hid(msg.chat_id_, msg.id_, 1, HidTwixTEAM, 1, 'md') end
end
--     Source Twix     --
if text == 'تفعيل كشف الاعدادات' and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل كشف الاعدادات'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:LockSettings'..msg.chat_id_,true)  
end
if text == 'تعطيل كشف الاعدادات' and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل كشف الاعدادات'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:LockSettings'..msg.chat_id_) 
end
--     Source Twix     --
if text == 'تفعيل اوامر التحشيش' and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل اوامر التحشيش'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:Stupid'..msg.chat_id_)
end
if text == 'تعطيل اوامر التحشيش' and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل اوامر التحشيش'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:Stupid'..msg.chat_id_,true)
end
--     Source Twix     --
if text and (text == 'تعطيل التحقق' or text == 'قفل التحقق' or text == 'تعطيل تنبيه الدخول') and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل التحقق بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:Robot'..msg.chat_id_)
end
if text and (text == 'تفعيل التحقق' or text == 'فتح التحقق' or text == 'تفعيل تنبيه الدخول') and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل التحقق بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:Robot'..msg.chat_id_,true)
end
--     Source Twix     --
if text == 'تفعيل ردود المدير' and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل ردود المدير'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:GpRed'..msg.chat_id_)
end
if text == 'تعطيل ردود المدير' and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل ردود المدير'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:GpRed'..msg.chat_id_,true)
end
--     Source Twix     --
if text == 'تفعيل ردود المطور' and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل ردود المطور'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:AllRed'..msg.chat_id_)
end
if text == 'تعطيل ردود المطور' and Manager(msg) and ChCheck(msg) then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل ردود المطور'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:AllRed'..msg.chat_id_,true)
end
--     Source Twix     --
if SecondSudo(msg) then
if text == 'تفعيل المغادره' or text == '𓄂 تفعيل المغادره ⸙' then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل المغادره بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix.."Hid:Left:Bot"..Twix)
end
if text == 'تعطيل المغادره' or text == '𓄂 تعطيل المغادره ⸙' then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل المغادره بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix.."Hid:Left:Bot"..Twix,true) 
end 
if text == 'تفعيل الاذاعه' or text == '𓄂 تفعيل الاذاعه ⸙' then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الاذاعه بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix.."Hid:Send:Bot"..Twix)
end
if text == 'تعطيل الاذاعه' or text == '𓄂 تعطيل الاذاعه ⸙' then 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الاذاعه بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix.."Hid:Send:Bot"..Twix,true) 
end
end
--     Source Twix     --
if text and text:match("^ضع اسم (.*)$") and Manager(msg) and ChCheck(msg) then
local txt = {string.match(text, "^(ضع اسم) (.*)$")}
tdcli_function ({ ID = "ChangeChatTitle",chat_id_ = msg.chat_id_,title_ = txt[2] },function(arg,data) 
if data.message_ == "Channel chat title can be changed by administrators only" then
send(msg.chat_id_,msg.id_,"⸙ ¦ البوت ليس ادمن يرجى ترقيتي !")  
return false  
end 
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⸙ ¦ ليست لدي صلاحية تغير معلومات المجموعه يرجى التحقق من الصلاحيات")  
else
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تغير اسم المجموعه'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
end,nil) 
end
--     Source Twix     --
if msg.content_.photo_ then
if DevHid:get(Twix..'Hid:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_) then
if msg.content_.photo_.sizes_[3] then
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
else
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
tdcli_function ({ID = "ChangeChatPhoto",chat_id_ = msg.chat_id_,photo_ = getInputFile(photo_id) }, function(arg,data)   
if data.code_ == 3 then
send(msg.chat_id_, msg.id_,"⸙ ¦ عذرا البوت ليس ادمن يرجى ترقيتي والمحاوله لاحقا") 
DevHid:del(Twix..'Hid:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
return false  end
if data.message_ == "CHAT_ADMIN_REQUIRED" then 
send(msg.chat_id_, msg.id_,"⸙ ¦ ليست لدي صلاحية تغير معلومات المجموعه يرجى التحقق من الصلاحيات") 
DevHid:del(Twix..'Hid:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
else
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تغير صورة المجموعه'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end
end,nil) 
DevHid:del(Twix..'Hid:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_)
end 
end
if text and text:match("^ضع صوره$") and ChCheck(msg) or text and text:match("^وضع صوره$") and ChCheck(msg) then
Dev_Hid(msg.chat_id_,msg.id_, 1, '⸙ ¦ ارسل صورة المجموعه الان', 1, 'md')
DevHid:set(Twix..'Hid:SetPhoto'..msg.chat_id_..':'..msg.sender_user_id_,true)
end
--     Source Twix     --
if text and text:match("^حذف الصوره$") and ChCheck(msg) or text and text:match("^مسح الصوره$") and ChCheck(msg) then
https.request("https://api.telegram.org/bot"..TokenBot.."/deleteChatPhoto?chat_id="..msg.chat_id_) 
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف صورة المجموعه")  
return false  
end
--     Source Twix     --
if Manager(msg) then
if text and text:match("^الغاء تثبيت$") and ChCheck(msg) or text and text:match("^الغاء التثبيت$") and ChCheck(msg) then
if DevHid:sismember(Twix.."Hid:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Hid(msg.chat_id_,msg.id_, 1, "⸙ ¦ التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
if data.ID == "Ok" then
DevHid:del(Twix..'Hid:PinnedMsg'..msg.chat_id_)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم الغاء تثبيت الرساله'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
return false  
end
if data.code_ == 6 then
send(msg.chat_id_,msg.id_,"⸙ ¦ انا لست ادمن هنا يرجى ترقيتي ادمن ثم اعد المحاوله")  
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⸙ ¦ ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات")  
return false  
end
end,nil)
end
--     Source Twix     --
if text and text:match("^الغاء تثبيت الكل$") then  
if DevHid:sismember(Twix.."Hid:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Hid(msg.chat_id_,msg.id_, 1, "⸙ ¦ التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
if data.ID == "Ok" then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم الغاء تثبيت الكل'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
https.request('https://api.telegram.org/bot'..TokenBot..'/unpinAllChatMessages?chat_id='..msg.chat_id_)
DevHid:del(Twix.."Hid:PinnedMsg"..msg.chat_id_)
return false  
end
if data.code_ == 6 then
send(msg.chat_id_,msg.id_,"⸙ ¦ انا لست ادمن هنا يرجى ترقيتي ادمن ثم اعد المحاوله")  
return false  
end
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⸙ ¦ ليست لدي صلاحية التثبيت يرجى التحقق من الصلاحيات")  
return false  
end
end,nil)
end
--     Source Twix     --
if text and text:match("^اعاده تثبيت$") and ChCheck(msg) or text and text:match("^اعاده التثبيت$") and ChCheck(msg) or text and text:match("^اعادة التثبيت$") and ChCheck(msg) then
if DevHid:sismember(Twix.."Hid:Lock:Pinpin",msg.chat_id_) and not BasicConstructor(msg) then
Dev_Hid(msg.chat_id_,msg.id_, 1, "⸙ ¦ التثبيت والغاء واعادة التثبيت تم قفله من قبل المنشئين الاساسيين", 1, 'md')
return false  
end
local pin_id = DevHid:get(Twix..'Hid:PinnedMsg'..msg.chat_id_)
if pin_id then
pin(msg.chat_id_,pin_id,0)
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم اعادة تثبيت الرساله'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end end
end
--     Source Twix     --
if text == 'طرد المحذوفين' or text == 'مسح المحذوفين' or text == 'طرد الحسابات المحذوفه' or text == 'حذف المحذوفين' then  
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),offset_ = 0,limit_ = 1000}, function(arg,del)
for k, v in pairs(del.members_) do
tdcli_function({ID = "GetUser",user_id_ = v.user_id_},function(b,data) 
if data.first_name_ == false then
ChatKick(msg.chat_id_, data.id_)
end
end,nil)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم طرد المحذوفين")  
end,nil)
end
--     Source Twix     --
if text and text:match("^مسح المحظورين$") or text and text:match("^حذف المحظورين$") and ChCheck(msg) or text and text:match("^مسح المطرودين$") or text and text:match("^حذف المطرودين$") and ChCheck(msg) then
local function RemoveBlockList(extra, result)
if tonumber(result.total_count_) == 0 then 
Dev_Hid(msg.chat_id_, msg.id_, 0,'⸙ ¦ *لا يوجد محظورين*', 1, 'md')
DevHid:del(Twix..'Hid:Ban:'..msg.chat_id_)
else
local x = 0
for x,y in pairs(result.members_) do
changeChatMemberStatus(msg.chat_id_, y.user_id_, 'Left', dl_cb, nil)
DevHid:del(Twix..'Hid:Ban:'..msg.chat_id_)
x = x + 1
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف المحظورين")  
end
end
tdcli_function({ID="GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersKicked"},offset_ = 0,limit_ = 200}, RemoveBlockList, {chat_id_ = msg.chat_id_, msg_id_ = msg.id_})    
end
end
--     Source Twix     --
if text and text:match("^معلومات المجموعه$") and ChCheck(msg) or text and text:match("^عدد الاعضاء$") and ChCheck(msg) or text and text:match("^عدد الكروب$") and ChCheck(msg) or text and text:match("^عدد الادمنيه$") and ChCheck(msg) or text and text:match("^عدد المحظورين$") and ChCheck(msg) then
local Muted = DevHid:scard(Twix.."Hid:Muted:"..msg.chat_id_) or "0"
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
tdcli_function({ID="GetChannelFull",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المجموعه 𓄂 ❨ '..dp.title_..' ❩\n⸙ ¦ الايدي 𓄂 ❨ '..msg.chat_id_..' ❩\n⸙ ¦ عدد الاعضاء 𓄂 ❨ *'..data.member_count_..'* ❩\n⸙ ¦ عدد الادمنيه 𓄂 ❨ *'..data.administrator_count_..'* ❩\n⸙ ¦ عدد المطرودين 𓄂 ❨ *'..data.kicked_count_..'* ❩\n⸙ ¦ عدد المكتومين 𓄂 ❨ *'..Muted..'* ❩\n⸙ ¦ عدد رسائل المجموعه 𓄂 ❨ *'..(msg.id_/2097152/0.5)..'* ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n', 1, 'md') 
end,nil)
end,nil)
end
--     Source Twix     --
if text and text:match('^كشف (-%d+)') then
local ChatId = text:match('كشف (-%d+)') 
if not SudoBot(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطورين فقط', 1, 'md')
else
local ConstructorList = DevHid:scard(Twix.."Hid:Constructor:"..ChatId) or 0
local BanedList = DevHid:scard(Twix.."Hid:Ban:"..ChatId) or 0
local ManagerList = DevHid:scard(Twix.."Hid:Managers:"..ChatId) or 0
local MutedList = DevHid:scard(Twix.."Hid:Muted:"..ChatId) or 0
local TkeedList = DevHid:scard(Twix.."Hid:Hid:Tkeed:"..ChatId) or 0
local AdminsList = DevHid:scard(Twix.."Hid:Admins:"..ChatId) or 0
local VipList = DevHid:scard(Twix.."Hid:VipMem:"..ChatId) or 0
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..ChatId))
if LinkGp.ok == true then LinkGroup = LinkGp.result else LinkGroup = 't.me/x_xxax' end
tdcli_function({ID ="GetChat",chat_id_=ChatId},function(arg,dp)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = ChatId:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
if dp.id_ then
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
Manager_id = admins[i].user_id_
tdcli_function ({ID = "GetUser",user_id_ = Manager_id},function(arg,Hid) 
if Hid.first_name_ ~= false then
ConstructorHid = "["..Hid.first_name_.."](T.me/"..(Hid.username_ or "x_xxax")..")"
else 
ConstructorHid = "حساب محذوف"
end
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ المجموعه 𓄂 ["..dp.title_.."]("..LinkGroup..")\n⸙ ¦ الايدي 𓄂 ( `"..ChatId.."` )\n⸙ ¦ المنشئ 𓄂 "..ConstructorHid.."\n⸙ ¦ عدد المدراء 𓄂 ( *"..ManagerList.."* )\n⸙ ¦ عدد المنشئين 𓄂 ( *"..ConstructorList.."* )\n⸙ ¦ عدد الادمنيه 𓄂 ( *"..AdminsList.."* )\n⸙ ¦ عدد المميزين 𓄂 ( *"..VipList.."* )\n⸙ ¦ عدد المحظورين 𓄂 ( *"..BanedList.."* )\n⸙ ¦ عدد المقيدين 𓄂 ( *"..TkeedList.."* )\n⸙ ¦ عدد المكتومين 𓄂 ( *"..MutedList.."* )", 1,"md")
end,nil)
end
end
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لم تتم اضافتي بها لاقوم بكشفها", 1, "md")
end
end,nil)
end,nil)
end 
end
--     Source Twix     --
if text and text:match("^غادر (-%d+)$")  then
local Text = { string.match(text, "^(غادر) (-%d+)$")}
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط', 1, 'md')
else 
tdcli_function({ID ="GetChat",chat_id_=Text[2]},function(arg,dp) 
if dp.id_ then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ المجموعه 𓄂 ["..dp.title_.."]\n⸙ ¦ تمت المغادره منها بنجاح", 1, "md")
Dev_Hid(Text[2], 0, 1, "⸙ ¦ بامر المطور تم مغادرة هذه المجموعه ", 1, "md")  
ChatLeave(dp.id_, Twix)
DevHid:srem(Twix.."Hid:Groups", dp.id_)
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لم تتم اضافتي بها لاقوم بمغادرتها", 1, "md")
end 
end,nil)
end 
end
--     Source Twix     --
if text and text:match("^تعين عدد الاعضاء (%d+)$") and SecondSudo(msg) or text and text:match("^تعيين عدد الاعضاء (%d+)$") and SecondSudo(msg) then
local Num = text:match("تعين عدد الاعضاء (%d+)$") or text:match("تعيين عدد الاعضاء (%d+)$")
DevHid:set(Twix..'Hid:Num:Add:Bot',Num) 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم وضع عدد الاعضاء 𓄂 *'..Num..'* عضو', 1, 'md')
end
--     Source Twix     --
if text == 'تفعيل البوت الخدمي' then 
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط', 1, 'md')
else 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل البوت الخدمي'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:FreeBot'..Twix) 
end 
end
if text == 'تعطيل البوت الخدمي' then 
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط', 1, 'md')
else 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل البوت الخدمي'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:FreeBot'..Twix,true) 
end 
end
if ChatType == 'sp' or ChatType == 'gp'  then
if text == 'تفعيل الالعاب' and Manager(msg) and ChCheck(msg) or text == 'تفعيل اللعبه' and Manager(msg) and ChCheck(msg) then   
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل الالعاب بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix..'Hid:Lock:Games'..msg.chat_id_) 
end
if text == 'تعطيل الالعاب' and Manager(msg) and ChCheck(msg) or text == 'تعطيل اللعبه' and Manager(msg) and ChCheck(msg) then  
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل الالعاب بنجاح'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix..'Hid:Lock:Games'..msg.chat_id_,true)  
end
if text == "تفعيل الرابط" or text == "تفعيل جلب الرابط" then 
if Admin(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تفعيل جلب رابط المجموعه'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:del(Twix.."Hid:Lock:GpLinks"..msg.chat_id_)
return false  
end
end
if text == "تعطيل الرابط" or text == "تعطيل جلب الرابط" then 
if Admin(msg) then
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم تعطيل جلب رابط المجموعه'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
DevHid:set(Twix.."Hid:Lock:GpLinks"..msg.chat_id_,"ok")
return false  
end
end
--     Source Twix     --
if text and text:match('^تفعيل$') and SudoBot(msg) and ChCheck(msg) then
if ChatType ~= 'sp' then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي', 1, 'md')
return false
end
if msg.can_be_deleted_ == false then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ البوت ليس ادمن يرجى ترقيتي !', 1, 'md')
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
if tonumber(data.member_count_) < tonumber(DevHid:get(Twix..'Hid:Num:Add:Bot') or 0) and not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عدد اعضاء المجموعه اقل من 𓄂 *'..(DevHid:get(Twix..'Hid:Num:Add:Bot') or 0)..'* عضو', 1, 'md')
return false
end
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
DevHid:del(Twix..'Hid:HidConstructor:'..msg.chat_id_)
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,abbas) 
local admins = abbas.members_
for i=0 , #admins do
if abbas.members_[i].bot_info_ == false and abbas.members_[i].status_.ID == "ChatMemberStatusEditor" then
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevHid:srem(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)
end
end,nil)
else
DevHid:sadd(Twix..'Hid:Admins:'..msg.chat_id_, admins[i].user_id_)
end
if abbas.members_[i].status_.ID == "ChatMemberStatusCreator" then
DevHid:sadd(Twix.."Hid:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevHid:sadd(Twix.."Hid:HidConstructor:"..msg.chat_id_,admins[i].user_id_)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,ba) 
if ba.first_name_ == false then
DevHid:srem(Twix.."Hid:BasicConstructor:"..msg.chat_id_,admins[i].user_id_)
DevHid:srem(Twix.."Hid:HidConstructor:"..msg.chat_id_,admins[i].user_id_)
end
end,nil)  
end 
end
end,nil)
if DevHid:sismember(Twix..'Hid:Groups',msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المجموعه بالتاكيد مفعله', 1, 'md')
else
ReplyStatus(msg,result.id_,"ReplyBy","⸙ ¦ تم تفعيل المجموعه "..dp.title_)  
DevHid:sadd(Twix.."Hid:Groups",msg.chat_id_)
if not DevHid:get(Twix..'Hid:SudosGp'..msg.sender_user_id_..msg.chat_id_) and not SecondSudo(msg) then 
DevHid:incrby(Twix..'Hid:Sudos'..msg.sender_user_id_,1)
DevHid:set(Twix..'Hid:SudosGp'..msg.sender_user_id_..msg.chat_id_,"Hid")
end
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NumMem = data.member_count_
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevHid:set(Twix.."Hid:Groups:Links"..msg.chat_id_,LinkGroup) 
if not Sudo(msg) then
SendText(DevId,"⸙ ¦ تم تفعيل مجموعه جديده 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ بواسطة 𓄂 "..Name.."\n⸙ ¦ اسم المجموعه 𓄂 ["..NameChat.."]\n⸙ ¦ عدد اعضاء المجموعه 𓄂 ❨ *"..NumMem.."* ❩\n⸙ ¦ ايدي المجموعه 𓄂 ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⸙ ¦ رابط المجموعه 𓄂 ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الوقت 𓄂 "..os.date("%I:%M%p").."\n⸙ ¦ التاريخ 𓄂 "..os.date("%Y/%m/%d").."",0,'md')
end
end
end,nil)
end,nil)
end,nil)
end
if text == 'تعطيل' and SudoBot(msg) and ChCheck(msg) then
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
if not DevHid:sismember(Twix..'Hid:Groups',msg.chat_id_) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ المجموعه بالتاكيد معطله', 1, 'md')
else
ReplyStatus(msg,result.id_,"ReplyBy","⸙ ¦ تم تعطيل المجموعه "..dp.title_)  
DevHid:srem(Twix.."Hid:Groups",msg.chat_id_)
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
DevHid:set(Twix.."Hid:Groups:Links"..msg.chat_id_,LinkGroup) 
if not Sudo(msg) then
SendText(DevId,"⸙ ¦ تم تعطيل مجموعه جديده 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ بواسطة 𓄂 "..Name.."\n⸙ ¦ اسم المجموعه 𓄂 ["..NameChat.."]\n⸙ ¦ ايدي المجموعه 𓄂 ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⸙ ¦ رابط المجموعه 𓄂 ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الوقت 𓄂 "..os.date("%I:%M%p").."\n⸙ ¦ التاريخ 𓄂 "..os.date("%Y/%m/%d").."",0,'md')
end
end
end,nil)
end,nil)
end
end
--     Source Twix     --
if text and text:match("^المطور$") then
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,dp) 
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("'","") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = dp.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("'","") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local LinkGp = json:decode(https.request('https://api.telegram.org/bot'..TokenBot..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkGp.ok == true then 
LinkGroup = LinkGp.result
else
LinkGroup = 'لا يوجد'
end
if not Sudo(msg) then
SendText(DevId,"⸙ ¦ هناك من بحاجه الى مساعده 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الشخص 𓄂 "..Name.."\n⸙ ¦ اسم المجموعه 𓄂 ["..NameChat.."]\n⸙ ¦ ايدي المجموعه 𓄂 ⤈ \n❨ `"..msg.chat_id_.."` ❩\n⸙ ¦ رابط المجموعه 𓄂 ⤈\n❨ ["..LinkGroup.."] ❩\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الوقت 𓄂 "..os.date("%I:%M%p").."\n⸙ ¦ التاريخ 𓄂 "..os.date("%Y/%m/%d").."",0,'md')
end
end,nil)
end,nil)
end
--     Source Twix     --
if text == 'جلب نسخه السورس' then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
sendDocument(DevId, 0, 0, 1, nil, './Twix.lua', dl_cb, nil)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عزيزي المطور تم ارسال نسخة ملف السورس الى الخاص', 1, 'md')
end end
--     Source Twix     --
if text == 'روابط الكروبات' or text == 'روابط المجموعات' then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
local List = DevHid:smembers(Twix.."Hid:Groups")
if #List == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لا يوجد مجموعات مفعله', 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ جاري ارسال نسخه تحتوي على '..#List..' مجموعه', 1, 'md')
local text = "⸙ ¦ Source Twix\n⸙ ¦ File Bot Groups\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(List) do
local GroupsManagers = DevHid:scard(Twix.."Hid:Managers:"..v) or 0
local GroupsAdmins = DevHid:scard(Twix.."Hid:Admins:"..v) or 0
local Groupslink = DevHid:get(Twix.."Hid:Groups:Links" ..v)
text = text..k.." ↬ ⤈ \n⸙ ¦ Group ID ↬ "..v.."\n⸙ ¦ Group Link ↬ "..(Groupslink or "Not Found").."\n⸙ ¦ Group Managers ↬ "..GroupsManagers.."\n⸙ ¦ Group Admins ↬ "..GroupsAdmins.."\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
end
local File = io.open('GroupsBot.txt', 'w')
File:write(text)
File:close()
local abbas = 'https://api.telegram.org/bot' .. TokenBot .. '/sendDocument'
local curl = 'curl "' .. abbas .. '" -F "chat_id=' .. msg.chat_id_ .. '" -F "document=@' .. 'GroupsBot.txt' .. '"'
io.popen(curl)
end
end
end
--     Source Twix     --
if text == "اذاعه بالخاص" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "𓄂 اذاعه خاص ⸙" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevHid:get(Twix.."Hid:Send:Bot"..Twix) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⸙ ¦ الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevHid:setex(Twix.."Hid:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ ارسل لي سواء 𓄂 ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⸙ ¦ للخروج ارسل 𓄂 ( الغاء ) \n ✓'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevHid:get(Twix.."Hid:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevHid:del(Twix.."Hid:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
List = DevHid:smembers(Twix..'Hid:Users') 
if msg.content_.text_ then
for k,v in pairs(List) do 
HidText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
HidText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
HidText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
HidText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
HidText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
HidText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
HidText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
HidText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اذاعة "..HidText.." بنجاح \n⸙ ¦ ‏الى 𓄂 ❨ "..#List.." ❩ مشترك \n ✓", 1, 'md')
DevHid:del(Twix.."Hid:Send:Pv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
--     Source Twix     --
if text == "اذاعه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "𓄂 اذاعه عام ⸙" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevHid:get(Twix.."Hid:Send:Bot"..Twix) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⸙ ¦ الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevHid:setex(Twix.."Hid:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ ارسل لي سواء 𓄂 ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⸙ ¦ للخروج ارسل 𓄂 ( الغاء ) \n ✓'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevHid:get(Twix.."Hid:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevHid:del(Twix.."Hid:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
List = DevHid:smembers(Twix..'Hid:Groups') 
if msg.content_.text_ then
for k,v in pairs(List) do 
HidText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
HidText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
HidText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
HidText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
HidText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
HidText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
HidText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
HidText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اذاعة "..HidText.." بنجاح \n⸙ ¦ ‏في 𓄂 ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevHid:del(Twix.."Hid:Send:Gp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
--     Source Twix     --
if text == "اذاعه بالتوجيه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "𓄂 اذاعه عام بالتوجيه ⸙" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevHid:get(Twix.."Hid:Send:Bot"..Twix) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⸙ ¦ الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevHid:setex(Twix.."Hid:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ ارسل الرساله الان لتوجيها \n⸙ ¦ للخروج ارسل 𓄂 ( الغاء ) \n ✓'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevHid:get(Twix.."Hid:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevHid:del(Twix.."Hid:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
local List = DevHid:smembers(Twix..'Hid:Groups')   
for k,v in pairs(List) do  
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = msg.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اذاعة رسالتك بالتوجيه \n⸙ ¦ ‏في 𓄂 ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevHid:del(Twix.."Hid:Send:FwdGp" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
--     Source Twix     --
if text == "اذاعه خاص بالتوجيه" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "𓄂 اذاعه خاص بالتوجيه ⸙" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevHid:get(Twix.."Hid:Send:Bot"..Twix) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⸙ ¦ الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevHid:setex(Twix.."Hid:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ ارسل الرساله الان لتوجيها \n⸙ ¦ للخروج ارسل 𓄂 ( الغاء ) \n ✓'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevHid:get(Twix.."Hid:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == 'الغاء' then   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevHid:del(Twix.."Hid:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
local List = DevHid:smembers(Twix..'Hid:Users')   
for k,v in pairs(List) do  
tdcli_function({ID="ForwardMessages", chat_id_ = v, from_chat_id_ = msg.chat_id_, message_ids_ = {[0] = msg.id_}, disable_notification_ = 0, from_background_ = 1},function(a,t) end,nil) 
end   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اذاعة رسالتك بالتوجيه \n⸙ ¦ ‏الى 𓄂 ❨ "..#List.." ❩ مشترك \n ✓", 1, 'md')
DevHid:del(Twix.."Hid:Send:FwdPv" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end
--     Source Twix     --
if text == "اذاعه بالتثبيت" and msg.reply_to_message_id_ == 0 and SudoBot(msg) or text == "𓄂 اذاعه بالتثبيت ⸙" and msg.reply_to_message_id_ == 0 and SudoBot(msg) then 
if DevHid:get(Twix.."Hid:Send:Bot"..Twix) and not SecondSudo(msg) then 
send(msg.chat_id_, msg.id_,"⸙ ¦ الاذاعه معطله من قبل المطور الاساسي")
return false
end
DevHid:setex(Twix.."Hid:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ ارسل لي سواء 𓄂 ⤈ \n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⸙ ¦ للخروج ارسل 𓄂 ( الغاء ) \n ✓'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
return false
end 
if DevHid:get(Twix.."Hid:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" then   
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء امر الاذاعه بنجاح", 1, 'md')
DevHid:del(Twix.."Hid:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
local List = DevHid:smembers(Twix.."Hid:Groups") 
if msg.content_.text_ then
for k,v in pairs(List) do 
HidText = "الرساله"
send(v, 0,"["..msg.content_.text_.."]") 
DevHid:set(Twix..'Hid:PinnedMsgs'..v,msg.content_.text_) 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(List) do 
HidText = "الصوره"
sendPhoto(v, 0, 0, 1, nil, photo,(msg.content_.caption_ or ''))
DevHid:set(Twix..'Hid:PinnedMsgs'..v,photo) 
end 
elseif msg.content_.animation_ then
for k,v in pairs(List) do 
HidText = "المتحركه"
sendDocument(v, 0, 0, 1,nil, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ''))    
DevHid:set(Twix..'Hid:PinnedMsgs'..v,msg.content_.animation_.animation_.persistent_id_)
end 
elseif msg.content_.video_ then
for k,v in pairs(List) do 
HidText = "الفيديو"
sendVideo(v, 0, 0, 1, nil, msg.content_.video_.video_.persistent_id_,(msg.content_.caption_ or '')) 
DevHid:set(Twix..'Hid:PinnedMsgs'..v,msg.content_.video_.video_.persistent_id_)
end 
elseif msg.content_.voice_ then
for k,v in pairs(List) do 
HidText = "البصمه"
sendVoice(v, 0, 0, 1, nil, msg.content_.voice_.voice_.persistent_id_,(msg.content_.caption_ or '')) 
DevHid:set(Twix..'Hid:PinnedMsgs'..v,msg.content_.voice_.voice_.persistent_id_)
end 
elseif msg.content_.audio_ then
for k,v in pairs(List) do 
HidText = "الصوت"
sendAudio(v, 0, 0, 1, nil, msg.content_.audio_.audio_.persistent_id_,(msg.content_.caption_ or '')) 
DevHid:set(Twix..'Hid:PinnedMsgs'..v,msg.content_.audio_.audio_.persistent_id_)
end 
elseif msg.content_.document_ then
for k,v in pairs(List) do 
HidText = "الملف"
sendDocument(v, 0, 0, 1,nil, msg.content_.document_.document_.persistent_id_,(msg.content_.caption_ or ''))    
DevHid:set(Twix..'Hid:PinnedMsgs'..v,msg.content_.document_.document_.persistent_id_)
end 
elseif msg.content_.sticker_ then
for k,v in pairs(List) do 
HidText = "الملصق"
sendSticker(v, 0, 0, 1, nil, msg.content_.sticker_.sticker_.persistent_id_)   
DevHid:set(Twix..'Hid:PinnedMsgs'..v,msg.content_.sticker_.sticker_.persistent_id_) 
end 
end
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم اذاعة "..HidText.." بالتثبيت \n⸙ ¦ ‏في 𓄂 ❨ "..#List.." ❩ مجموعه \n ✓", 1, 'md')
DevHid:del(Twix.."Hid:Send:Gp:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end
--     Source Twix     --
if text == 'حذف رد' and Manager(msg) and ChCheck(msg) or text == 'مسح رد' and  Manager(msg) and ChCheck(msg) then
DevHid:set(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_,'DelGpRed')
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ حسنا ارسل الكلمه لحذفها " ,  1, "md")
return false
end
if text == 'اضف رد' and Manager(msg) and ChCheck(msg) then
DevHid:set(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_,'SetGpRed')
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ حسنا ارسل الكلمه الان " ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local SetGpRed = DevHid:get(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'')
if SetGpRed == 'SetGpRed' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل لي الرد سواء كان 𓄂 ⤈\n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⸙ ¦ يمكنك اضافة الى النص 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ معرف المستخدم\n `#msgs` ↬ عدد الرسائل\n `#name` ↬ اسم المستخدم\n `#id` ↬ ايدي المستخدم\n `#stast` ↬ رتبة المستخدم\n `#edit` ↬ عدد السحكات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ للخروج ارسل 𓄂 ( الغاء )\n ✓" ,  1, "md")
DevHid:set(Twix..'Hid:Add:GpRed'..msg.sender_user_id_..''..msg.chat_id_..'','SaveGpRed')
DevHid:set(Twix..'Hid:Add:GpText'..msg.sender_user_id_..''..msg.chat_id_..'',text)
DevHid:sadd(Twix..'Hid:Manager:GpRed'..msg.chat_id_..'',text)
DevHid:set(Twix..'DelManagerRep'..msg.chat_id_..'',text)
return false
end
end
--     Source Twix     --
if text == 'حذف رد عام' and SecondSudo(msg) or text == '𓄂 حذف رد عام ⸙' and SecondSudo(msg) or text == 'مسح رد عام' and SecondSudo(msg) then
DevHid:set(Twix.."Hid:Add:AllRed"..msg.sender_user_id_,'DelAllRed')
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ حسنا ارسل الكلمه لحذفها " ,  1, "md")
return false
end
if text == 'اضف رد عام' and SecondSudo(msg) or text == '𓄂 اضف رد عام ⸙' and SecondSudo(msg) then
DevHid:set(Twix.."Hid:Add:AllRed"..msg.sender_user_id_,'SetAllRed')
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ حسنا ارسل الكلمه الان " ,  1, "md")
return false
end
if text and text:match("^(.*)$") then
local SetAllRed = DevHid:get(Twix.."Hid:Add:AllRed"..msg.sender_user_id_)
if SetAllRed == 'SetAllRed' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل لي الرد سواء كان 𓄂 ⤈\n❨ ملف • ملصق • متحركه • صوره\n • فيديو • بصمه • صوت • رساله ❩\n⸙ ¦ يمكنك اضافة الى النص 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n `#username` ↬ معرف المستخدم\n `#msgs` ↬ عدد الرسائل\n `#name` ↬ اسم المستخدم\n `#id` ↬ ايدي المستخدم\n `#stast` ↬ رتبة المستخدم\n `#edit` ↬ عدد السحكات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ للخروج ارسل 𓄂 ( الغاء )\n ✓" ,  1, "md")
DevHid:set(Twix.."Hid:Add:AllRed"..msg.sender_user_id_,'SaveAllRed')
DevHid:set(Twix.."Hid:Add:AllText"..msg.sender_user_id_, text)
DevHid:sadd(Twix.."Hid:Sudo:AllRed",text)
DevHid:set(Twix.."DelSudoRep",text)
return false 
end end
--     Source Twix     --
if text == 'الردود' and Manager(msg) and ChCheck(msg) or text == 'ردود المدير' and Manager(msg) and ChCheck(msg) then
local redod = DevHid:smembers(Twix..'Hid:Manager:GpRed'..msg.chat_id_..'')
MsgRep = '⸙ ¦ ردود المدير 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
for k,v in pairs(redod) do
if DevHid:get(Twix.."Hid:Gif:GpRed"..v..msg.chat_id_) then
dp = 'متحركه 🎭'
elseif DevHid:get(Twix.."Hid:Voice:GpRed"..v..msg.chat_id_) then
dp = 'بصمه 🎙'
elseif DevHid:get(Twix.."Hid:Stecker:GpRed"..v..msg.chat_id_) then
dp = 'ملصق 🃏'
elseif DevHid:get(Twix.."Hid:Text:GpRed"..v..msg.chat_id_) then
dp = 'رساله ✉'
elseif DevHid:get(Twix.."Hid:Photo:GpRed"..v..msg.chat_id_) then
dp = 'صوره 🎇'
elseif DevHid:get(Twix.."Hid:Video:GpRed"..v..msg.chat_id_) then
dp = 'فيديو 📽'
elseif DevHid:get(Twix.."Hid:File:GpRed"..v..msg.chat_id_) then
dp = 'ملف 📁'
elseif DevHid:get(Twix.."Hid:Audio:GpRed"..v..msg.chat_id_) then
dp = 'اغنيه 🎶'
end
MsgRep = MsgRep..''..k..'~ (`'..v..'`) 𓄂 {*'..dp..'*}\n' 
end
if #redod == 0 then
MsgRep = '⸙ ¦ لا توجد ردود مضافه'
end
send(msg.chat_id_,msg.id_,MsgRep)
end
--     Source Twix     --
if text == 'حذف الردود' and Manager(msg) and ChCheck(msg) or text == 'مسح الردود' and Manager(msg) and ChCheck(msg) or text == 'حذف ردود المدير' and Manager(msg) and ChCheck(msg) or text == 'مسح ردود المدير' and Manager(msg) and ChCheck(msg) then
local redod = DevHid:smembers(Twix..'Hid:Manager:GpRed'..msg.chat_id_..'')
if #redod == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لا توجد ردود مضافه" ,  1, "md")
else
for k,v in pairs(redod) do
DevHid:del(Twix..'Hid:Gif:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:Voice:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:Audio:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:Photo:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:Stecker:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:Video:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:File:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:Text:GpRed'..v..msg.chat_id_)
DevHid:del(Twix..'Hid:Manager:GpRed'..msg.chat_id_)
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف ردود المدير")  
return false
end
end
--     Source Twix     --
if  text == "ردود المطور" and SecondSudo(msg) or text == "الردود العام" and SecondSudo(msg) or text == "ردود العام" and SecondSudo(msg) or text == "𓄂 الردود العام ⸙" and SecondSudo(msg) then
local redod = DevHid:smembers(Twix.."Hid:Sudo:AllRed")
MsgRep = '⸙ ¦ ردود المطور 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
for k,v in pairs(redod) do
if DevHid:get(Twix.."Hid:Gif:AllRed"..v) then
dp = 'متحركه 🎭'
elseif DevHid:get(Twix.."Hid:Voice:AllRed"..v) then
dp = 'بصمه 🎙'
elseif DevHid:get(Twix.."Hid:Stecker:AllRed"..v) then
dp = 'ملصق 🃏'
elseif DevHid:get(Twix.."Hid:Text:AllRed"..v) then
dp = 'رساله ✉'
elseif DevHid:get(Twix.."Hid:Photo:AllRed"..v) then
dp = 'صوره 🎇'
elseif DevHid:get(Twix.."Hid:Video:AllRed"..v) then
dp = 'فيديو 📽'
elseif DevHid:get(Twix.."Hid:File:AllRed"..v) then
dp = 'ملف 📁'
elseif DevHid:get(Twix.."Hid:Audio:AllRed"..v) then
dp = 'اغنيه 🎶'
end
MsgRep = MsgRep..''..k..'~ (`'..v..'`) 𓄂 {*'..dp..'*}\n' 
end
if #redod == 0 then
MsgRep = '⸙ ¦ لا توجد ردود مضافه'
end
send(msg.chat_id_,msg.id_,MsgRep)
end
--     Source Twix     --
if text == "حذف ردود المطور" and SecondSudo(msg) or text == "حذف ردود العام" and SecondSudo(msg) or text == "مسح ردود المطور" and SecondSudo(msg) then
local redod = DevHid:smembers(Twix.."Hid:Sudo:AllRed")
if #redod == 0 then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ لا توجد ردود مضافه" ,  1, "md")
else
for k,v in pairs(redod) do
DevHid:del(Twix.."Hid:Add:AllRed"..v)
DevHid:del(Twix.."Hid:Gif:AllRed"..v)
DevHid:del(Twix.."Hid:Voice:AllRed"..v)
DevHid:del(Twix.."Hid:Audio:AllRed"..v)
DevHid:del(Twix.."Hid:Photo:AllRed"..v)
DevHid:del(Twix.."Hid:Stecker:AllRed"..v)
DevHid:del(Twix.."Hid:Video:AllRed"..v)
DevHid:del(Twix.."Hid:File:AllRed"..v)
DevHid:del(Twix.."Hid:Text:AllRed"..v)
DevHid:del(Twix.."Hid:Sudo:AllRed")
end
ReplyStatus(msg,msg.sender_user_id_,"ReplyBy","⸙ ¦ تم حذف ردود المطور")  
return false
end
end 
--     Source Twix     --
if text and text == "تغيير اسم البوت" or text and text == "وضع اسم البوت" or text and text == "تغير اسم البوت" then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل لي اسم البوت الان" ,  1, "md") 
DevHid:set(Twix..'Hid:NameBot'..msg.sender_user_id_..'', 'msg')
return false 
end
end
if text and text == 'حذف اسم البوت' or text == 'مسح اسم البوت' then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
DevHid:del(Twix..'Hid:NameBot')
local HidTwixTEAM = '⸙ ¦ بواسطه‍ 𓄂 '..HidRank(msg)..' \n⸙ ¦ تم حذف اسم البوت'
Hidmoned(msg.chat_id_, msg.sender_user_id_, msg.id_, HidTwixTEAM, 14, string.len(msg.sender_user_id_))
end end 
--     Source Twix     --
if text and text:match("^استعاده الاوامر$") and SecondSudo(msg) or text and text:match("^استعادة كلايش الاوامر$") and SecondSudo(msg) then
HelpList ={'Hid:Help','Hid:Help1','Hid:Help2','Hid:Help3','Hid:Help4','Hid:Help5','Hid:Help6'}
for i,Help in pairs(HelpList) do
DevHid:del(Twix..Help) 
end
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم استعادة الكلايش الاصليه" ,  1, "md") 
end
if text == "تعيين الاوامر" and SecondSudo(msg) or text == "تعيين امر الاوامر" and SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة (الاوامر) الان " ,  1, "md")
DevHid:set(Twix..'Hid:Help0'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HidTwixTEAM =  DevHid:get(Twix..'Hid:Help0'..msg.sender_user_id_)
if HidTwixTEAM == 'msg' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الكليشه الجديده " ,  1, "md")
DevHid:del(Twix..'Hid:Help0'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Help', text)
Dev_Hid(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "الاوامر" or text == "اوامر" or text == "مساعده" then
if not Admin(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر يخص الرتب الاعلى فقط\n⸙ ¦ ارسل 𓄂 (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevHid:get(Twix..'Hid:Help')
local text =  [[
⸙ ¦ اهلا بك في قائمة الاوامر 𓄂 ⤈ 
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ م1 𓄂 اوامر الحمايه
⸙ ¦ م2 𓄂 اوامر الادمنيه
⸙ ¦ م3 𓄂 اوامر المدراء
⸙ ¦ م4 𓄂 اوامر المنشئين
⸙ ¦ م5 𓄂 اوامر المطورين
⸙ ¦ م6 𓄂 اوامر الاعضاء
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]] 
Dev_Hid(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end
end
if text == "تعيين امر م1" and SecondSudo(msg) or text == "تعيين امر م١" and SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة (م1) الان " ,  1, "md")
DevHid:set(Twix..'Hid:Help01'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HidTwixTEAM =  DevHid:get(Twix..'Hid:Help01'..msg.sender_user_id_)
if HidTwixTEAM == 'msg' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الكليشه الجديده " ,  1, "md")
DevHid:del(Twix..'Hid:Help01'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Help1', text)
Dev_Hid(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م1" or text == "م١" or text == "اوامر1" or text == "اوامر١" then
if not Admin(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر يخص الرتب الاعلى فقط\n⸙ ¦ ارسل 𓄂 (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevHid:get(Twix..'Hid:Help1')
local text =  [[
⸙ ¦ اوامر حماية المجموعه 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ قفل • فتح 𓄂 الروابط
⸙ ¦ قفل • فتح 𓄂 المعرفات
⸙ ¦ قفل • فتح 𓄂 البوتات
⸙ ¦ قفل • فتح 𓄂 المتحركه
⸙ ¦ قفل • فتح 𓄂 الملصقات
⸙ ¦ قفل • فتح 𓄂 الملفات
⸙ ¦ قفل • فتح 𓄂 الصور
⸙ ¦ قفل • فتح 𓄂 الفيديو
⸙ ¦ قفل • فتح 𓄂 الاونلاين
⸙ ¦ قفل • فتح 𓄂 الدردشه
⸙ ¦ قفل • فتح 𓄂 التوجيه
⸙ ¦ قفل • فتح 𓄂 الاغاني
⸙ ¦ قفل • فتح 𓄂 الصوت
⸙ ¦ قفل • فتح 𓄂 الجهات
⸙ ¦ قفل • فتح 𓄂 الماركداون
⸙ ¦ قفل • فتح 𓄂 التكرار
⸙ ¦ قفل • فتح 𓄂 الهاشتاك
⸙ ¦ قفل • فتح 𓄂 التعديل
⸙ ¦ قفل • فتح 𓄂 التثبيت
⸙ ¦ قفل • فتح 𓄂 الاشعارات
⸙ ¦ قفل • فتح 𓄂 الكلايش
⸙ ¦ قفل • فتح 𓄂 الدخول
⸙ ¦ قفل • فتح 𓄂 الشبكات
⸙ ¦ قفل • فتح 𓄂 المواقع
⸙ ¦ قفل • فتح 𓄂 الفشار
⸙ ¦ قفل • فتح 𓄂 الكفر
⸙ ¦ قفل • فتح 𓄂 الطائفيه
⸙ ¦ قفل • فتح 𓄂 الكل
⸙ ¦ قفل • فتح 𓄂 العربيه
⸙ ¦ قفل • فتح 𓄂 الانكليزيه
⸙ ¦ قفل • فتح 𓄂 الفارسيه
⸙ ¦ قفل • فتح 𓄂 التفليش
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ اوامر حمايه اخرى 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ قفل • فتح + الامر 𓄂 ⤈
⸙ ¦ التكرار بالطرد
⸙ ¦ التكرار بالكتم
⸙ ¦ التكرار بالتقيد
⸙ ¦ الفارسيه بالطرد
⸙ ¦ البوتات بالطرد
⸙ ¦ البوتات بالتقيد
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م2" and SecondSudo(msg) or text == "تعيين امر م٢" and SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة (م2) الان " ,  1, "md")
DevHid:set(Twix..'Hid:Help21'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HidTwixTEAM =  DevHid:get(Twix..'Hid:Help21'..msg.sender_user_id_)
if HidTwixTEAM == 'msg' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الكليشه الجديده " ,  1, "md")
DevHid:del(Twix..'Hid:Help21'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Help2', text)
Dev_Hid(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م2" or text == "م٢" or text == "اوامر2" or text == "اوامر٢" then
if not Admin(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر يخص الرتب الاعلى فقط\n⸙ ¦ ارسل 𓄂 (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevHid:get(Twix..'Hid:Help2')
local text =  [[
⸙ ¦ اوامر الادمنيه 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ الاعدادت
⸙ ¦ تاك للكل 
⸙ ¦ انشاء رابط
⸙ ¦ ضع وصف
⸙ ¦ ضع رابط
⸙ ¦ ضع صوره
⸙ ¦ حذف الرابط
⸙ ¦ حذف المطايه
⸙ ¦ كشف البوتات
⸙ ¦ طرد البوتات
⸙ ¦ تنظيف + العدد
⸙ ¦ تنظيف التعديل
⸙ ¦ كللهم + الكلمه
⸙ ¦ اسم البوت + الامر
⸙ ¦ ضع • حذف 𓄂 ترحيب
⸙ ¦ ضع • حذف 𓄂 قوانين
⸙ ¦ اضف • حذف 𓄂 صلاحيه
⸙ ¦ الصلاحيات • حذف الصلاحيات
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ ضع سبام + العدد
⸙ ¦ ضع تكرار + العدد
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ رفع مميز • تنزيل مميز
⸙ ¦ المميزين • حذف المميزين
⸙ ¦ كشف القيود • رفع القيود
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ حذف • مسح + بالرد
⸙ ¦ منع • الغاء منع
⸙ ¦ قائمه المنع
⸙ ¦ حذف قائمه المنع
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تفعيل • تعطيل 𓄂 الرابط
⸙ ¦ تفعيل • تعطيل 𓄂 الالعاب
⸙ ¦ تفعيل • تعطيل 𓄂 الترحيب
⸙ ¦ تفعيل • تعطيل 𓄂 كشف الاعدادات
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ طرد المحذوفين
⸙ ¦ طرد 𓄂 بالرد • بالمعرف • بالايدي
⸙ ¦ كتم • الغاء كتم
⸙ ¦ تقيد • الغاء تقيد
⸙ ¦ حظر • الغاء حظر
⸙ ¦ المكتومين • حذف المكتومين
⸙ ¦ المقيدين • حذف المقيدين
⸙ ¦ المحظورين • حذف المحظورين
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تقييد دقيقه + عدد الدقائق
⸙ ¦ تقييد ساعه + عدد الساعات
⸙ ¦ تقييد يوم + عدد الايام
⸙ ¦ الغاء تقييد 𓄂 لالغاء التقييد بالوقت
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م3" and SecondSudo(msg) or text == "تعيين امر م٣" and SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة (م3) الان " ,  1, "md")
DevHid:set(Twix..'Hid:Help31'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HidTwixTEAM =  DevHid:get(Twix..'Hid:Help31'..msg.sender_user_id_)
if HidTwixTEAM == 'msg' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الكليشه الجديده " ,  1, "md")
DevHid:del(Twix..'Hid:Help31'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Help3', text)
Dev_Hid(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م3" or text == "م٣" or text == "اوامر3" or text == "اوامر٣" then
if not Admin(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر يخص الرتب الاعلى فقط\n⸙ ¦ ارسل 𓄂 (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevHid:get(Twix..'Hid:Help3')
local text =  [[
⸙ ¦ اوامر المدراء 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ فحص البوت
⸙ ¦ ضع اسم + الاسم
⸙ ¦ اضف • حذف 𓄂 رد
⸙ ¦ ردود المدير
⸙ ¦ حذف ردود المدير
⸙ ¦ حذف قوائم المنع
⸙ ¦ منع 𓄂 بالرد على ( ملصق • صوره • متحركه )
⸙ ¦ حذف قائمه منع + 𓄂 ⤈
( الصور • المتحركات • الملصقات )
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تنزيل الكل
⸙ ¦ رفع ادمن • تنزيل ادمن
⸙ ¦ الادمنيه • حذف الادمنيه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تثبيت
⸙ ¦ الغاء التثبيت
⸙ ¦ اعاده التثبيت
⸙ ¦ الغاء تثبيت الكل
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تغير رد + اسم الرتبه + النص 𓄂 ⤈
⸙ ¦ المطور • منشئ الاساسي
⸙ ¦ المنشئ • المدير • الادمن
⸙ ¦ المميز • المنظف • العضو
⸙ ¦ حذف ردود الرتب
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تغيير الايدي 𓄂 لتغيير الكليشه
⸙ ¦ تعيين الايدي 𓄂 لتعيين الكليشه
⸙ ¦ حذف الايدي 𓄂 لحذف الكليشه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تفعيل • تعطيل + الامر 𓄂 ⤈
⸙ ¦ اطردني • الايدي بالصوره • الابراج
⸙ ¦ معاني الاسماء • اوامر النسب
⸙ ¦ الايدي • تحويل الصيغ • اوامر التحشيش
⸙ ¦ ردود المدير • ردود المطور • التحقق
⸙ ¦ ضافني • حساب العمر • الزخرفه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م4" and SecondSudo(msg) or text == "تعيين امر م٤" and SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة (م4) الان " ,  1, "md")
DevHid:set(Twix..'Hid:Help41'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HidTwixTEAM =  DevHid:get(Twix..'Hid:Help41'..msg.sender_user_id_)
if HidTwixTEAM == 'msg' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الكليشه الجديده" ,  1, "md")
DevHid:del(Twix..'Hid:Help41'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Help4', text)
Dev_Hid(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٤" or text == "م4" or text == "اوامر4" or text == "اوامر٤" then
if not Admin(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر يخص الرتب الاعلى فقط\n⸙ ¦ ارسل 𓄂 (م6) لعرض اوامر الاعضاء', 1, 'md')
else
local Help = DevHid:get(Twix..'Hid:Help4')
local text =  [[
⸙ ¦ اوامر المنشئين 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تنزيل الكل
⸙ ¦ الميديا • امسح
⸙ ¦ ترتيب الاوامر
⸙ ¦ اضف • حذف 𓄂 امر
⸙ ¦ حذف الاوامر المضافه
⸙ ¦ الاوامر المضافه
⸙ ¦ اضف نقاط 𓄂 بالرد • بالايدي
⸙ ¦ اضف رسائل 𓄂 بالرد • بالايدي
⸙ ¦ رفع منظف • تنزيل منظف
⸙ ¦ المنظفين • حذف المنظفين
⸙ ¦ رفع مدير • تنزيل مدير
⸙ ¦ المدراء • حذف المدراء
⸙ ¦ تفعيل • تعطيل + الامر 𓄂 ⤈
⸙ ¦ نزلني • امسح
⸙ ¦ الحظر • الكتم
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ اوامر المنشئين الاساسيين 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ وضع لقب + اللقب
⸙ ¦ تفعيل • تعطيل 𓄂 الرفع
⸙ ¦ رفع منشئ • تنزيل منشئ
⸙ ¦ المنشئين • حذف المنشئين
⸙ ¦ رفع • تنزيل 𓄂 مشرف
⸙ ¦ رفع بكل الصلاحيات
⸙ ¦ حذف القوائم
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ اوامر منشئ المجموعه 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ رفع • تنزيل 𓄂 منشئ اساسي
⸙ ¦ حذف المنشئين الاساسيين 
⸙ ¦ المنشئين الاساسيين 
⸙ ¦ حذف جميع الرتب
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م5" and SecondSudo(msg) or text == "تعيين امر م٥" and SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة (م5) الان " ,  1, "md")
DevHid:set(Twix..'Hid:Help51'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HidTwixTEAM =  DevHid:get(Twix..'Hid:Help51'..msg.sender_user_id_)
if HidTwixTEAM == 'msg' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الكليشه الجديده " ,  1, "md")
DevHid:del(Twix..'Hid:Help51'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Help5', text)
Dev_Hid(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٥" or text == "م5" or text == "اوامر5" or text == "اوامر٥" then
if not SudoBot(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ هذا الامر للمطورين فقط', 1, 'md')
else
local Help = DevHid:get(Twix..'Hid:Help5')
local text =  [[
⸙ ¦ اوامر المطورين 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ الكروبات
⸙ ¦ المطورين
⸙ ¦ المشتركين
⸙ ¦ الاحصائيات
⸙ ¦ المجموعات
⸙ ¦ اسم البوت + غادر
⸙ ¦ اسم البوت + تعطيل
⸙ ¦ كشف + -ايدي المجموعه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ رفع • تنزيل 𓄂 مدير عام
⸙ ¦ حذف • المدراء العامين 
⸙ ¦ رفع • تنزيل 𓄂 ادمن عام
⸙ ¦ حذف • الادمنيه العامين 
⸙ ¦ رفع • تنزيل 𓄂 مميز عام
⸙ ¦ حذف • المميزين عام 
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ اوامر المطور الاساسي 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تحديث
⸙ ¦ الملفات
⸙ ¦ المتجر
⸙ ¦ السيرفر
⸙ ¦ روابط الكروبات
⸙ ¦ تحديث السورس
⸙ ¦ تنظيف الكروبات
⸙ ¦ تنظيف المشتركين
⸙ ¦ حذف جميع الملفات
⸙ ¦ تعيين الايدي العام
⸙ ¦ تغير المطور الاساسي
⸙ ¦ حذف معلومات الترحيب
⸙ ¦ تغير معلومات الترحيب
⸙ ¦ غادر + -ايدي المجموعه
⸙ ¦ تعيين عدد الاعضاء + العدد
⸙ ¦ حظر عام • الغاء العام
⸙ ¦ كتم عام • الغاء العام
⸙ ¦ قائمه العام • حذف قائمه العام
⸙ ¦ وضع • حذف 𓄂 اسم البوت
⸙ ¦ اضف • حذف 𓄂 رد عام
⸙ ¦ ردود المطور • حذف ردود المطور
⸙ ¦ تعيين • حذف • جلب 𓄂 رد الخاص
⸙ ¦ جلب نسخه الكروبات
⸙ ¦ رفع النسخه + بالرد على الملف
⸙ ¦ تعيين • حذف 𓄂 قناة الاشتراك
⸙ ¦ جلب كليشه الاشتراك
⸙ ¦ تغيير • حذف 𓄂 كليشه الاشتراك
⸙ ¦ رفع • تنزيل 𓄂 مطور
⸙ ¦ المطورين • حذف المطورين
⸙ ¦ رفع • تنزيل 𓄂 مطور ثانوي
⸙ ¦ الثانويين • حذف الثانويين
⸙ ¦ تعيين • حذف 𓄂 كليشة الايدي
⸙ ¦ اذاعه للكل بالتوجيه 𓄂 بالرد
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ تفعيل ملف + اسم الملف
⸙ ¦ تعطيل ملف + اسم الملف
⸙ ¦ تفعيل • تعطيل + الامر 𓄂 ⤈
⸙ ¦ الاذاعه • الاشتراك الاجباري
⸙ ¦ ترحيب البوت • المغادره
⸙ ¦ البوت الخدمي • التواصل
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end end
if text == "تعيين امر م6" and SecondSudo(msg) or text == "تعيين امر م٦" and SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة (م6) الان " ,  1, "md")
DevHid:set(Twix..'Hid:Help61'..msg.sender_user_id_, 'msg')
return false end
if text and text:match("^(.*)$") then
local HidTwixTEAM =  DevHid:get(Twix..'Hid:Help61'..msg.sender_user_id_)
if HidTwixTEAM == 'msg' then
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ الكليشه الجديده" ,  1, "md")
DevHid:del(Twix..'Hid:Help61'..msg.sender_user_id_)
DevHid:set(Twix..'Hid:Help6', text)
Dev_Hid(msg.chat_id_, msg.id_, 1, text , 1, 'md')
return false end
end
if text == "م٦" or text == "م6" or text == "اوامر6" or text == "اوامر٦" then
local Help = DevHid:get(Twix..'Hid:Help6')
local text =  [[
⸙ ¦ اوامر الاعضاء 𓄂 ⤈
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ السورس • موقعي • رتبتي • معلوماتي 
⸙ ¦ رسائلي • حذف رسائلي • اسمي • معرفي 
⸙ ¦ ايدي •ايديي • جهاتي • غنيلي • الالعاب 
⸙ ¦ نقاطي • بيع نقاطي • القوانين • زخرفه 
⸙ ¦ رابط الحذف • نزلني • اطردني • المطور 
⸙ ¦ منو ضافني • مشاهدات المنشور • الرابط 
⸙ ¦ رقمي •ايدي المجموعه • معلومات المجموعه 
⸙ ¦ نسبه الحب • نسبه الكره • نسبه الغباء 
⸙ ¦ نسبه الرجوله • نسبه الانوثه • التفاعل
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ صلاحياتي
⸙ ¦ كول + الكلمه
⸙ ¦ زخرفه + اسمك
⸙ ¦ برج + نوع البرج
⸙ ¦ معنى اسم + الاسم
⸙ ¦ احسب + تاريخ ميلادك
⸙ ¦ بوسه • بوسها 𓄂 بالرد
⸙ ¦ رفع مطي • تنزيل مطي •المطايه
⸙ ¦ هينه • هينها 𓄂 بالرد • بالمعرف
⸙ ¦ صيحه • صيحها 𓄂 بالرد • بالمعرف
⸙ ¦ صلاحياته 𓄂 بالرد • بالمعرف • بالايدي
⸙ ¦ ايدي • كشف  𓄂 بالرد • بالمعرف • بالايدي
⸙ ¦ تحويل + بالرد 𓄂 صوره • ملصق • صوت • بصمه
┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
⸙ ¦ [Source Channel](https://t.me/x_xxax)
]]
Dev_Hid(msg.chat_id_, msg.id_, 1, (Help or text), 1, 'md')
end
--     Source Twix     --
if SecondSudo(msg) then
if text == "تحديث السورس" or text == "تحديث سورس" then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ جاري تحديث سورس تويكس', 1, 'md') 
os.execute('rm -rf Twix.lua') 
os.execute('wget https://raw.githubusercontent.com/HidTwixTEAM/Twix/master/Twix.lua') 
dofile('Twix.lua') 
io.popen("rm -rf ../.telegram-cli/*")
print("\27[31;47m\n          ( تم تحديث السورس )          \n\27[0;34;49m\n") 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم التحديث الى الاصدار الجديد', 1, 'md') 
end
if text == 'تحديث' or text == 'تحديث البوت' or text == '𓄂 تحديث ⸙' then  
dofile('Twix.lua') 
io.popen("rm -rf ../.telegram-cli/*")
print("\27[31;47m\n        ( تم تحديث ملفات البوت )        \n\27[0;34;49m\n") 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم تحديث ملفات البوت", 1, "md")
end 
--     Source Twix     --
if text == 'الملفات' then
Files = '\n⸙ ¦ الملفات المفعله في البوت 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
i = 0
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
i = i + 1
Files = Files..i..'~ : `'..v..'`\n'
end
end
if i == 0 then
Files = '⸙ ¦ لا توجد ملفات في البوت'
end
send(msg.chat_id_, msg.id_,Files)
end
if text == "متجر الملفات" or text == 'المتجر' then
local Get_Files, res = https.request("https://raw.githubusercontent.com/HidTwixTEAM/TwixFiles/master/getfile.json")
if res == 200 then
local Get_info, res = pcall(JSON.decode,Get_Files);
vardump(res.plugins_)
if Get_info then
local TextS = "\n⸙ ¦ قائمة ملفات متجر سورس تويكس\n⸙ ¦ الملفات المتوفره حاليا 𓄂 ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
local TextE = "┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ علامة 𓄂 (✔) تعني الملف مفعل\n⸙ ¦ علامة 𓄂 (✖️) تعني الملف معطل\n"
local NumFile = 0
for name,Info in pairs(res.plugins_) do
local CheckFileisFound = io.open("Files/"..name,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
CheckFile = "(✔)"
else
CheckFile = "(✖️)"
end
NumFile = NumFile + 1
TextS = TextS.."⸙ ¦ "..Info..' 𓄂 ⤈\n'..NumFile.."~ : `"..name..'` ↬ '..CheckFile.."\n"
end
send(msg.chat_id_, msg.id_,TextS..TextE) 
end
else
send(msg.chat_id_, msg.id_,"⸙ ¦ لا يوجد اتصال من الـapi") 
end
end
if text == "مسح جميع الملفات" or text == "حذف جميع الملفات" then
os.execute("rm -fr Files/*")
send(msg.chat_id_,msg.id_,"⸙ ¦ تم حذف جميع الملفات المفعله")
end
if text and text:match("^(تعطيل ملف) (.*)(.lua)$") then
local FileGet = {string.match(text, "^(تعطيل ملف) (.*)(.lua)$")}
local FileName = FileGet[2]..'.lua'
local GetJson, Res = https.request("https://raw.githubusercontent.com/HidTwixTEAM/TwixFiles/master/TwixFiles/"..FileName)
if Res == 200 then
os.execute("rm -fr Files/"..FileName)
send(msg.chat_id_, msg.id_,"\n⸙ ¦ الملف 𓄂 *"..FileName.."*\n⸙ ¦ تم تعطيله وحذفه من البوت بنجاح") 
dofile('Twix.lua')  
else
send(msg.chat_id_, msg.id_,"⸙ ¦ لا يوجد ملف بهذا الاسم") 
end
end
if text and text:match("^(تفعيل ملف) (.*)(.lua)$") then
local FileGet = {string.match(text, "^(تفعيل ملف) (.*)(.lua)$")}
local FileName = FileGet[2]..'.lua'
local GetJson, Res = https.request("https://raw.githubusercontent.com/HidTwixTEAM/TwixFiles/master/TwixFiles/"..FileName)
if Res == 200 then
local ChekAuto = io.open("Files/"..FileName,'w+')
ChekAuto:write(GetJson)
ChekAuto:close()
send(msg.chat_id_, msg.id_,"\n⸙ ¦ الملف 𓄂 *"..FileName.."*\n⸙ ¦ تم تفعيله في البوت بنجاح") 
dofile('Twix.lua')  
else
send(msg.chat_id_, msg.id_,"⸙ ¦ لا يوجد ملف بهذا الاسم") 
end
return false
end
end 
--     Source Twix     --
if text and (text == 'حذف معلومات الترحيب' or text == 'مسح معلومات الترحيب') and SecondSudo(msg) then    
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم حذف معلومات الترحيب', 1, 'md')   
DevHid:del(Twix..'Hid:Text:BotWelcome')
DevHid:del(Twix..'Hid:Photo:BotWelcome')
return false
end 
if text and (text == 'تفعيل ترحيب البوت' or text == 'تفعيل معلومات الترحيب') and SecondSudo(msg) then    
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تفعيل الترحيب عند اضافة البوت في المجموعه', 1, 'md')   
DevHid:del(Twix..'Hid:Lock:BotWelcome')
return false
end 
if text and (text == 'تعطيل ترحيب البوت' or text == 'تعطيل معلومات الترحيب') and SecondSudo(msg) then    
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تعطيل الترحيب عند اضافة البوت في المجموعه', 1, 'md')   
DevHid:set(Twix..'Hid:Lock:BotWelcome',true)
return false
end 
if text and (text == 'تغير معلومات الترحيب' or text == 'تغيير معلومات الترحيب' or text == '𓄂 تغير معلومات الترحيب ⸙') and SecondSudo(msg) then    
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ ارسل لي نص الترحيب', 1, 'md') 
DevHid:del(Twix..'Hid:Text:BotWelcome')
DevHid:del(Twix..'Hid:Photo:BotWelcome')
DevHid:set(Twix.."Hid:Set:BotWelcome"..msg.sender_user_id_,"Text") 
return false
end 
if text and DevHid:get(Twix.."Hid:Set:BotWelcome"..msg.sender_user_id_) == 'Text' then 
if text and text:match("^الغاء$") then 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء الامر", 1, "md") 
DevHid:del(Twix.."Hid:Set:BotWelcome"..msg.sender_user_id_)   
return false
end 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ النص ارسل لي صورة الترحيب\n⸙ ¦ ارسل 𓄂 الغاء لحفظ النص فقط", 1, 'md')   
DevHid:set(Twix.."Hid:Text:BotWelcome",text) 
DevHid:set(Twix.."Hid:Set:BotWelcome"..msg.sender_user_id_,"Photo") 
return false 
end 
if DevHid:get(Twix.."Hid:Set:BotWelcome"..msg.sender_user_id_) == 'Photo' then 
if text and text:match("^الغاء$") then 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ النص والغاء حفظ صورة الترحيب", 1, "md") 
DevHid:del(Twix.."Hid:Set:BotWelcome"..msg.sender_user_id_)    
return false
end 
if msg.content_.photo_ and msg.content_.photo_.sizes_[1] then   
DevHid:set(Twix.."Hid:Photo:BotWelcome",msg.content_.photo_.sizes_[1].photo_.persistent_id_)
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حفظ النص وصورة الترحيب", 1, 'md')   
DevHid:del(Twix.."Hid:Set:BotWelcome"..msg.sender_user_id_)   
end
return false
end
--     Source Twix     --
if text and text:match("^ضع كليشه المطور$") or text and text:match("^وضع كليشه المطور$") or text and text:match("^تغيير كليشه المطور$") then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ ارسل كليشة المطور الان ", 1, "md")
DevHid:setex(Twix.."Hid:DevText" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 300, true)
end end
if text and text:match("^مسح كليشه المطور$") or text and text:match("^حذف كليشه المطور$") then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم حذف كليشة المطور", 1, "md")
DevHid:del(Twix.."DevText")
end end
--     Source Twix     --
if DevHid:get(Twix.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
Dev_Hid(msg.chat_id_, msg.id_, 1, "⸙ ¦ تم الغاء الامر", 1, "md") 
DevHid:del(Twix.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  end 
DevHid:del(Twix.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local texxt = string.match(text, "(.*)") 
DevHid:set(Twix..'Hid:textch:user',texxt)
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ تم تغيير كليشة الاشتراك الاجباري', 1, 'md')
end
if text and text:match("^تغير كليشه الاشتراك$") and SecondSudo(msg) or text and text:match("^تغيير كليشه الاشتراك$") and SecondSudo(msg) then  
DevHid:setex(Twix.."textch:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 300, true)  
local text = '⸙ ¦ حسنا ارسل كليشة الاشتراك الجديده'  
Dev_Hid(msg.chat_id_, msg.id_, 1,text, 1, 'md') 
end
if text == "حذف كليشه الاشتراك الاجباري" or text == "حذف كليشه الاشتراك" then  
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
DevHid:del(Twix..'Hid:textch:user')
textt = "⸙ ¦ تم حذف كليشة الاشتراك الاجباري"
Dev_Hid(msg.chat_id_, msg.id_, 1,textt, 1, 'md') 
end end
if text == 'كليشه الاشتراك' or text == 'جلب كليشه الاشتراك' then
if not SecondSudo(msg) then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ للمطور الاساسي فقط ', 1, 'md')
else
local chtext = DevHid:get(Twix.."Hid:textch:user")
if chtext then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ كليشة الاشتراك 𓄂 ⤈ \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n['..chtext..']', 1, 'md')
else
local DevHid6 = DevHid:get(Twix.."DevHid3")
if DevHid6 then
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ عليك الاشتراك في قناة البوت \n⸙ ¦ قناة البوت 𓄂 '..DevHid6, 1, "html")
else
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ لم يتم تعيين قناة الاشتراك الاجباري \n⸙ ¦ ارسل 𓄂 تعيين قناة الاشتراك للتعيين ', 1, 'md')
end end end end
--     Source Twix     --
if text == 'القناة' or text == 'قناة السورس' or text == 'قناه السورس' or text == 'قنات السورس' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, '⸙ ¦ Channel ↬ @x_xxax', 1, 'html')    
end 
--     Source Twix     --
if Sudo(msg) then 
if text == 'معلومات السيرفر' or text == 'السيرفر' then 
Dev_Hid(msg.chat_id_, msg.id_, 1, io.popen([[
LinuxVersion=`lsb_release -ds`
MemoryUsage=`free -m | awk 'NR==2{printf "%s/%sMB {%.2f%%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
Percentage=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
UpTime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}'`
echo '⸙ ¦ نظام التشغيل 𓄂 ⤈\n`'"$LinuxVersion"'`' 
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الذاكره العشوائيه 𓄂 ⤈\n`'"$MemoryUsage"'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ وحدة التخزين 𓄂 ⤈\n`'"$HardDisk"'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ المعالج 𓄂 ⤈\n`'"`grep -c processor /proc/cpuinfo`""Core ~ {$Percentage%} "'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ الدخول 𓄂 ⤈\n`'`whoami`'`'
echo '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ مدة تشغيل السيرفر 𓄂 ⤈\n`'"$UpTime"'`'
]]):read('*a'), 1, 'md')
end
end
--     Source Twix     --
TwixFiles(msg)
--     Source Twix     --
elseif (data.ID == "UpdateMessageEdited") then
local msg = data
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.message_id_)},function(extra, result, success)
DevHid:incr(Twix..'Hid:EditMsg'..result.chat_id_..result.sender_user_id_)
local text = result.content_.text_ or result.content_.caption_
local Text = result.content_.text_
if DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) and not Text and not BasicConstructor(result) then
DeleteMessage(msg.chat_id_,{[0] = data.message_id_})
Media = 'الميديا'
if result.content_.ID == "MessagePhoto" then Media = 'الصوره'
elseif result.content_.ID == "MessageSticker" then Media = 'الملصق'
elseif result.content_.ID == "MessageVoice" then Media = 'البصمه'
elseif result.content_.ID == "MessageAudio" then Media = 'الصوت'
elseif result.content_.ID == "MessageVideo" then Media = 'الفيديو'
elseif result.content_.ID == "MessageAnimation" then Media = 'المتحركه'
end
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,dp) 
local Hidname = '⸙ ¦ العضو 𓄂 ['..dp.first_name_..'](tg://user?id='..dp.id_..')'
local Hidid = '⸙ ¦ ايديه 𓄂 `'..dp.id_..'`'
local Hidtext = '⸙ ¦ قام بالتعديل على '..Media
local Hidtxt = '┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⸙ ¦ تعالو يامشرفين اكو مخرب'
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,abbas) 
local admins = abbas.members_  
text = '\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n'
for i=0 , #admins do 
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,data) 
if data.first_name_ ~= false then
text = text.."~ [@"..data.username_.."]\n"
end
if #admins == i then 
SendText(msg.chat_id_, Hidname..'\n'..Hidid..'\n'..Hidtext..text..Hidtxt,0,'md') 
end
end,nil)
end
end,nil)
end,nil)
end
if not VipMem(result) then
Filters(result, text)
if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") or text:match("#") or text:match("@") or text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match("[Ww][Ww][Ww].") or text:match(".[Xx][Yy][Zz]") then
if DevHid:get(Twix..'Hid:Lock:EditMsgs'..msg.chat_id_) then
DeleteMessage(msg.chat_id_,{[0] = data.message_id_})
end end end 
end,nil)
--     Source Twix     --
elseif (data.ID == "UpdateMessageSendSucceeded") then
local msg = data.message_
local text = msg.content_.text_
local GetMsgPin = DevHid:get(Twix..'Hid:PinnedMsgs'..msg.chat_id_)
if GetMsgPin ~= nil then
if text == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) if dp.ID == 'Ok' then;DevHid:del(Twix..'Hid:PinnedMsgs'..msg.chat_id_);end;end,nil)   
elseif (msg.content_.sticker_) then 
if GetMsgPin == msg.content_.sticker_.sticker_.persistent_id_ then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevHid:del(Twix..'Hid:PinnedMsgs'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.animation_) then 
if msg.content_.animation_.animation_.persistent_id_ == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevHid:del(Twix..'Hid:PinnedMsgs'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.photo_) then
if msg.content_.photo_.sizes_[0] then
id_photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
id_photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
id_photo = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
id_photo = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
if id_photo == GetMsgPin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,dp) DevHid:del(Twix..'Hid:PinnedMsgs'..msg.chat_id_) end,nil)   
end end end
--     Source Twix     --
elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
print('\27[30;32mجاري تنظيف المجموعات الوهميه يرجى الانتظار\n\27[1;37m')
local PvList = DevHid:smembers(Twix..'Hid:Users')  
for k,v in pairs(PvList) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data) end,nil) 
end 
local GpList = DevHid:smembers(Twix..'Hid:Groups') 
for k,v in pairs(GpList) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
tdcli_function({ID = "ChangeChatMemberStatus",chat_id_=v,user_id_=Twix,status_={ID = "ChatMemberStatusLeft"},},function(e,g) end, nil) 
DevHid:srem(Twix..'Hid:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
DevHid:srem(Twix..'Hid:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
DevHid:srem(Twix..'Hid:Groups',v)  
end
if data and data.code_ and data.code_ == 400 then
DevHid:srem(Twix..'Hid:Groups',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusEditor" then
DevHid:sadd(Twix..'Hid:Groups',v)  
end end,nil) end
end
--     Source Twix     --
end 
