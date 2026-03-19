<%@ Page Language="VB" %>
<script runat="server">

    ' Insert page code here
    '
    
    Sub Button1_Click(sender As Object, e As EventArgs)
    
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql,Gender,PurposeOfReg as string
        Dim DOB as date
    
    
    
        if rbMale.Checked="True" then Gender = "M" else Gender = "F"
        if rbResellerPurpose.Checked="True" then PurposeOfReg = "Resseller Purpose" else PurposeOfReg = "Company Usage"
    
    
        StrSql = "Insert into SharkMembersProfile(Name,Gender,DOB,NRIC,PurposeOfReg,JobPosition,howToKnowUs,CompanyName,CompanyReg,CompanyTel,CompanyFax,mobilePhone,EmailAdd,Address1,Address2,PostalCode,State,Town,Country,UserName,Pwd,ReferalCode,DateApply,DateApproved,MemberStatus) "
        StrSql = StrSql & "Select '" & trim(txtName.text) & "','" & trim(Gender) & "','" & cdate(DOB) & "',"
        StrSql = StrSql & "'" & trim(txtNRIC.text) & "','" & trim(PurposeOfReg) & "','" & trim(txtJobPosition.text) & "',"
        StrSql = StrSql & "'" & trim(cmbHowToKnowUs.text) & "','" & trim(txtCompanyName.text) & "','" & trim(txtCompanyReg.text) & "',"
        StrSql = StrSql & "'" & trim(txtCompanyTel.text) & "','" & trim(txtCompanyFax.text) & "','" & trim(txtmobilePhone.text) & "',"
        StrSql = StrSql & "'" & trim(txtEmailAdd.text) & "','" & trim(txtAddress1.text) & "','" & trim(txtAddress2.text) & "',"
        StrSql = StrSql & "'" & trim(txtPostalCode.text) & "','" & trim(cmbState.text) & "','" & trim(txtTown.text) & "',"
        StrSql = StrSql & "'" & trim(cmbCountry.text) & "','" & trim(txtUserName.text) & "','" & trim(txtPwd.text) & "'"
        StrSql = StrSql & "'" & trim(ReferalCode.text) & "','" & now & "','" & now & "','Non Active'"
    
        ReqCOM.ExecuteNonQuery(StrSql)
    
    
    
    
    
    ',,DateApply,DateApproved,MemberStatus
    
    'Name,Gender,DOB,NRIC,PurposeOfReg,JobPosition,howToKnowUs,CompanyName,CompanyReg,CompanyTel,CompanyFax,mobilePhone,EmailAdd,Address1,Address2,PostalCode,State,Town,Country,UserName,Pwd,ReferalCode,DateApply,DateApproved,MemberStatus
    
    
    
    End Sub

</script>
<html>
<head>
</head>
<body>
    <form runat="server">
        <p>
            <table width="709">
                <tbody>
                    <tr>
                        <td>
                            <table style="HEIGHT: 385px" width="100%" border="1">
                                <tbody valign="top">
                                    <tr>
                                        <td>
                                            <asp:Label id="Label1" runat="server">1.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label10" runat="server">Name</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label19" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtName" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label2" runat="server">2.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label11" runat="server">Gender</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label20" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbMale" runat="server" GroupName="Gender" Checked="True" Text="Male"></asp:RadioButton>
                                            <asp:RadioButton id="rbFemale" runat="server" GroupName="Gender" Text="Female"></asp:RadioButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label3" runat="server">3.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label12" runat="server">Date Of Birth</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label21" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:DropDownList id="cmbDay" runat="server">
                                                <asp:ListItem Value="--">--</asp:ListItem>
                                            </asp:DropDownList>
                                            /<asp:DropDownList id="cmbMonth" runat="server">
                                                <asp:ListItem Value="--">--</asp:ListItem>
                                            </asp:DropDownList>
                                            /<asp:DropDownList id="cmbYear" runat="server">
                                                <asp:ListItem Value="--">--</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label4" runat="server">4.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label13" runat="server">NRIC</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label22" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtNRIC" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label5" runat="server">5.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label14" runat="server">Purpose of using our printing services</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label26" runat="server">ii</asp:Label></td>
                                        <td>
                                            <p>
                                                <asp:RadioButton id="rbResellerPurpose" runat="server" GroupName="PurposeOfJoining" Text="For Reselling Purpose"></asp:RadioButton>
                                                <asp:RadioButton id="rbCompanyUsage" runat="server" GroupName="PurposeOfJoining" Text="For Company Usage"></asp:RadioButton>
                                            </p>
                                            <p>
                                                <asp:DropDownList id="DropDownList4" runat="server" Width="217px">
                                                    <asp:ListItem Value="Please select line of work">Please select line of work</asp:ListItem>
                                                </asp:DropDownList>
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label6" runat="server">6.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label15" runat="server">Job position</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label27" runat="server">ii</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtJobPosition" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label7" runat="server">7.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label16" runat="server">How do you know us</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label23" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:DropDownList id="cmbHowToKnowUs" runat="server" Width="217px">
                                                <asp:ListItem Value="Please select how do you know us">Please select how do you know us</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label8" runat="server">8.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label17" runat="server">Name of company</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label24" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtCompanyName" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label9" runat="server">9.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label18" runat="server">Company Registration No</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label25" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtCompanyRegNo" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label40" runat="server">10.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label28" runat="server">Tel</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label52" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtCompanyTel" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label41" runat="server">11.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label29" runat="server">Fax</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label53" runat="server">ii</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtCompanyFax" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label42" runat="server">12.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label30" runat="server">Mobile phone</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label54" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtMobileNo" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label43" runat="server">13.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label31" runat="server">Email address</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label55" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtEMail" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label44" runat="server">14.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label32" runat="server">Re-enter email address</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label56" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtEmail1" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label45" runat="server">ii</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label33" runat="server">ii</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label62" runat="server">ii</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="TextBox15" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label46" runat="server">15.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label34" runat="server">Address (Line1)</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label57" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtAdd1" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label47" runat="server">ii</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label35" runat="server">(Line2)</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label63" runat="server">ii</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtAdd2" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label48" runat="server">16.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label36" runat="server">Postcode</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label58" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtPostalCode" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label49" runat="server">17.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label37" runat="server">State</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label59" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:DropDownList id="cmbState" runat="server" Width="217px">
                                                <asp:ListItem Value="Johor">Johor</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label50" runat="server">18.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label38" runat="server">Town</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label60" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtTown" runat="server" Width="192px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label51" runat="server">19.</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label39" runat="server">Country</asp:Label></td>
                                        <td>
                                            <asp:Label id="Label61" runat="server">*</asp:Label></td>
                                        <td>
                                            <asp:DropDownList id="cmbCountry" runat="server" Width="217px">
                                                <asp:ListItem Value="Malaysia">Malaysia</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <p>
                                <table width="100%" border="1">
                                    <tbody>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 25px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td colspan="3">
                                                <asp:Label id="Label70" runat="server">Please choose a username and a password you
                                                can easily remember</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="Label64" runat="server">20.</asp:Label></td>
                                            <td>
                                                <asp:Label id="Label65" runat="server">Username</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtUserName" runat="server" Width="192px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="Label66" runat="server">21.</asp:Label></td>
                                            <td>
                                                <asp:Label id="Label68" runat="server">Password</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtPwd" runat="server" Width="192px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="Label67" runat="server">22.</asp:Label></td>
                                            <td>
                                                <asp:Label id="Label69" runat="server">Password again</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtPwd1" runat="server" Width="192px"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label id="Label71" runat="server">If you were introduced by another member, enter
                                                his/her member code below. otherwise, leave this section blank.</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="Label72" runat="server">Introducer Member Code</asp:Label>&nbsp; 
                                                <asp:TextBox id="TextBox19" runat="server" Width="192px"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 71px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:Label id="Label73" runat="server">Please proof check the email address you have
                                                    entered. This is the email address we will send your registration confirmation as
                                                    soon as we receive your payment.</asp:Label><asp:Label id="Label75" runat="server">Before
                                                    clicking the 'Continue' button, you must agree with our Member Terms & Conditions.</asp:Label>
                                                </p>
                                                <p>
                                                    <asp:RadioButton id="RadioButton5" runat="server" Text="Agree"></asp:RadioButton>
                                                    <asp:RadioButton id="RadioButton6" runat="server" Text="Disagree"></asp:RadioButton>
                                                </p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp; 
                                                <asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Continue"></asp:Button>
                                                <asp:Button id="Button2" runat="server" Text="Reset"></asp:Button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <!-- Insert content here -->
    </form>
    <p>
    </p>
    <p>
    </p>
    <p>
    </p>
    <p>
        7:46 - 7:49 
    </p>
    <p>
        8:08 - 8:40 
    </p>
    <p>
        6:11 - 6:36 
    </p>
</body>
</html>
