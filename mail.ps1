#Declare Parameters

$clientID = “your ID from App Registration”
$clientSecret = “your client secret from App Registration”
$tenantID = “your tenant ID”

##Run Script##

#Connect to GRAPH API

$MailSender = "who email will be from"

#Connect to GRAPH API
$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
}
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $tokenBody
$headers = @{
    "Authorization" = "Bearer $($tokenResponse.access_token)"
    "Content-type"  = "application/json"
}


$HTMLBody = @"
<!DOCTYPE html>
<html>
<head>
<style>
* {
'box-sizing: border-box;
}
.row {
margin-left:-5px;
margin-right:-5px;
}
.column {
'float: left;
'width: 20%;
padding: 5px;
}
/* Clearfix (clear floats) */
.row::after {
content: \"\";
clear: both;
display: table;
}
table {
font-family: verdana;
font-size: 10pt;
border-collapse: collapse;
border-spacing: 0;
height: 100px;
width: 315px;
border-right:1px solid black;
padding: 0px;
}
th, td {
text-align: left;
padding: 0px;
}
p {
 margin-top: 2;
 margin-bottom: 2;
}
</style>
<html>
<body>
<p>Here is the Contact Information that you require.</p>
<br>
<table style=\"width:100%\">
  <tr>
    <th>Company Name</th>
    <th>Contact Name</th> 
    <th>Email Address</th>
  </tr>
  <tr>
    <td>John Doe</td>
    <td>Acme Co.</td>
    <td>jdoe@acme.com</td>
  </tr>
  <tr>
    <td>Eve Jackson</td>
    <td>Jackson Inc.</td>
    <td>ej@jakson.com</td>
  </tr>
  <tr>
    <td>Bruce Wayne</td>
    <td>Wayne Enterprises</td>
    <td>batman@wayne.com</td>
  </tr>
</table>
<br>
<p>Sincerely,</P>
<p>Sales</p>
</body>
</html>
"@

$msg = $HTMLBody

#Send Mail    
$URLsend = "https://graph.microsoft.com/v1.0/users/$MailSender/sendMail"
$BodyJsonsend = @"
                    {
                        "message": {
                          "subject": "Customer Information",
                          "body": {
                            "contentType": "HTML",
                            "content": "$msg"

                          },
                          "toRecipients": [
                            {
                              "emailAddress": {
                                "address": "email address to"
                              }
                            }
                          ]
                        },
                        "saveToSentItems": "false"
                      }
"@

Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $BodyJsonsend


_________________________________________________________