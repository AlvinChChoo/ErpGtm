<%@ Page Language="VB" %>
<html>
<head>
    <script language="JavaScript">
<!--
function setDisableButtonTimer(){
	 disableButtonTimer = setInterval("disableButton()", 5000);

}

function disableButton(){
document.form1.btnSubmit.disabled = true;
clearInterval(disableButtonTimer);
}

-->
</script>
</head>
<body onload="setDisableButtonTimer();">
    <form name="form1" action="test.asp" method="post">
        <select multiple="multiple" size="11" name="MyListBox">
            <option value="0">CustomerID<option value="1">CompanyName<option value="2">ContactName<option value="3">ContactTitle<option value="4">Address<option value="5">City<option value="6">Region<option value="7">PostalCode<option value="8">Country<option value="9">Phone<option value="10">Fax</option>
                                                </option>
                                            </option>
                                        </option>
                                    </option>
                                </option>
                            </option>
                        </option>
                    </option>
                </option>
            </option>
        </select>
        <p>
            <input type="submit" value="Submit Query" name="btnSubmit" />&nbsp;&nbsp; 
            <input type="reset" value="Reset" />
        </p>
    </form>
</body>
</html>