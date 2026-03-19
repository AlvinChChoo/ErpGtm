<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.IO" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dissql("Select BOM_Quote_No from BOM_Quote_M where Import_model_no is null and Import_File_Name is null","BOM_Quote_No","BOM_Quote_No",cmbBOMQuoteNo)
    End Sub
    
    Sub cmdImportTransData_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then ImportTextData
    End sub
    
    Sub ImportTextData()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim LineIn as string
        Dim oFile as System.IO.File
        Dim oRead as System.IO.StreamReader
        Dim i as integer
        Dim StrCtrl() as string
        Dim Str,MainPart,PartNo,CustPartNo,PartDesc,PartSpec,VenCode,VenName,mfgMPN,CurrCode,QuoteRem as string
        Dim PUsageTemp,LeadTimeTemp,SPQTemp,MOQTemp,UPTemp as string
        Dim LeadTime,SPQ,MOQ as long
        Dim PUsage,UP as decimal
        Dim TotalLen,LeftStr as integer
    
        try
            ReqCOM.ExecuteNonQuery("Truncate Table Import_Bom_Quote")
            fileControl.PostedFile.SaveAs((Mappath("") + "\BOMQuote.csv"))
    
            oRead = oFile.OpenText(Mappath("") + “\BOMQuote.csv”)
            While oRead.Peek <> -1
                LineIn = oRead.ReadLine()
                Str = LineIn
                Str = Replace(Str,"'","`")
    
    
                    For i = 1 to 15
                        if i <> 15 then
                            if Str.SubString(0,1) = """" then
                                TotalLen = len(Str)
                                LeftStr = instr(Str,"""")
                                Str = (right(Str,len(Str) - (instr(Str,""""))))
                                TotalLen = len(Str)
                                LeftStr = instr(Str,"""")
    
                                if i = 1 then
                                    MainPart = trim(left(Str,LeftStr))
                                    MainPart = rtrim(MainPart)
                                    MainPart = ltrim(MainPart)
                                Elseif i = 2 then
                                    PartNo = trim(left(Str,LeftStr))
                                    PartNo = rtrim(PartNo)
                                    PartNo = ltrim(PartNo)
                                Elseif i = 3 then
                                    CustPartNo = trim(left(Str,LeftStr))
                                    CustPartNo = rtrim(CustPartNo)
                                    CustPartNo = ltrim(CustPartNo)
    
                                Elseif i = 4 then
                                    PartDesc = trim(left(Str,LeftStr))
                                    PartDesc = rtrim(PartDesc)
                                    PartDesc = ltrim(PartDesc)
                                Elseif i = 5 then
                                    PartSpec = trim(left(Str,LeftStr))
                                    PartSpec = rtrim(PartSpec)
                                    PartSpec = ltrim(PartSpec)
                                Elseif i = 6 then
                                    if trim(left(Str,LeftStr)) = "" then PUsageTemp = "0"
                                    if trim(left(Str,LeftStr)) <> "" then PUsageTemp = left(Str,LeftStr)
                                Elseif i = 7 then
                                    VenCode = trim(left(Str,LeftStr))
                                    VenCode = rtrim(VenCode)
                                    VenCode = ltrim(VenCode)
                                Elseif i = 8 then
                                    VenName = trim(left(Str,LeftStr))
                                    VenName = rtrim(VenName)
                                    VenName = ltrim(VenName)
                                Elseif i = 9 then
                                    mfgMPN = trim(left(Str,LeftStr))
                                    mfgMPN = rtrim(mfgMPN)
                                    mfgMPN = ltrim(mfgMPN)
                                Elseif i = 10 then
                                    CurrCode = trim(left(Str,LeftStr))
                                    CurrCode = rtrim(CurrCode)
                                    CurrCode = ltrim(CurrCode)
                                Elseif i = 11 then
                                    if trim(left(Str,LeftStr)) = "" then UPTemp = "0"
                                    if trim(left(Str,LeftStr)) <> "" then UPTemp = left(Str,LeftStr)
                                Elseif i = 12 then
                                    if trim(left(Str,LeftStr)) = "" then LeadTimeTemp = "0"
                                    if trim(left(Str,LeftStr)) <> "" then LeadTimeTemp = left(Str,LeftStr)
                                Elseif i = 13 then
                                    if trim(left(Str,LeftStr)) = "" then SPQTemp = "0"
                                    if trim(left(Str,LeftStr)) <> "" then SPQTemp = left(Str,LeftStr)
                                Elseif i = 14 then
                                    if trim(left(Str,LeftStr)) = "" then MOQTemp = "0"
                                    if trim(left(Str,LeftStr)) <> "" then MOQTemp = left(Str,LeftStr)
                                End if
                            Str = (right(Str,len(Str) - (instr(Str,""""))))
                            if str.substring(0,1) = "," then
                                Str = right(Str,len(Str) - 1)
                            end if
                        elseif Str.SubString(0,1) <> """" then
                            TotalLen = len(Str)
                            LeftStr = instr(Str,",")
    
                            if i = 1 then
                                MainPart = trim(left(Str,LeftStr))
                                MainPart = rtrim(MainPart)
                                MainPart = ltrim(MainPart)
                            Elseif i = 2 then
                                PartNo = trim(left(Str,LeftStr))
                                PartNo = rtrim(PartNo)
                                PartNo = ltrim(PartNo)
                            Elseif i = 3 then
                                CustPartNo = trim(left(Str,LeftStr))
                                CustPartNo = rtrim(CustPartNo)
                                CustPartNo = ltrim(CustPartNo)
                            Elseif i = 4 then
                                PartDesc = trim(left(Str,LeftStr))
                                PartDesc = rtrim(PartDesc)
                                PartDesc = ltrim(PartDesc)
                            Elseif i = 5 then
                                PartSpec = trim(left(Str,LeftStr))
                                PartSpec = rtrim(PartSpec)
                                PartSpec = ltrim(PartSpec)
                            Elseif i = 6 then
                                if trim(left(Str,LeftStr)) = "" then PUsageTemp = "0"
                                if trim(left(Str,LeftStr)) <> "" then PUsageTemp = left(Str,LeftStr)
                            Elseif i = 7 then
                                VenCode = trim(left(Str,LeftStr))
                                VenCode = rtrim(VenCode)
                                VenCode = ltrim(VenCode)
                            Elseif i = 8 then
                                VenName = trim(left(Str,LeftStr))
                                VenName = rtrim(VenName)
                                VenName = ltrim(VenName)
                            Elseif i = 9 then
                                mfgMPN = trim(left(Str,LeftStr))
                                mfgMPN = rtrim(mfgMPN)
                                mfgMPN = ltrim(mfgMPN)
                            Elseif i = 10 then
                                CurrCode = trim(left(Str,LeftStr))
                                CurrCode = rtrim(CurrCode)
                                CurrCode = ltrim(CurrCode)
                            Elseif i = 11 then
                                if trim(left(Str,LeftStr)) = "" then UPTemp = "0"
                                if trim(left(Str,LeftStr)) <> "" then UPTemp = left(Str,LeftStr)
    
                            Elseif i = 12 then
                                if trim(left(Str,LeftStr)) = "" then LeadTimeTemp = "0"
                                if trim(left(Str,LeftStr)) <> "" then LeadTimeTemp = left(Str,LeftStr)
                            Elseif i = 13 then
                                if trim(left(Str,LeftStr)) = "" then SPQTemp = "0"
                                if trim(left(Str,LeftStr)) <> "" then SPQTemp = left(Str,LeftStr)
                            Elseif i = 14 then
                                if trim(left(Str,LeftStr)) = "" then MOQTemp = "0"
                                if trim(left(Str,LeftStr)) <> "" then MOQTemp = left(Str,LeftStr)
                            End if
                        Str = (right(Str,len(Str) - (instr(Str,","))))
                    end if
                end if
    
                if i = 15 then QuoteRem = Str
            next i
    
                if MainPart.substring(len(MainPart)-1,1) = """" then MainPart = left(MainPart,len(MainPart)-1)
                if MainPart.substring(len(MainPart)-1,1) = "," then MainPart = left(MainPart,len(MainPart)-1)
    
                if PartNo.substring(len(PartNo)-1,1) = """" then PartNo = left(PartNo,len(PartNo)-1)
                if PartNo.substring(len(PartNo)-1,1) = "," then PartNo = left(PartNo,len(PartNo)-1)
    
                if CustPartNo.substring(len(CustPartNo)-1,1) = """" then CustPartNo = left(CustPartNo,len(CustPartNo)-1)
                if CustPartNo.substring(len(CustPartNo)-1,1) = "," then CustPartNo = left(CustPartNo,len(CustPartNo)-1)
    
                if PartDesc.substring(len(PartDesc)-1,1) = """" then PartDesc = left(PartDesc,len(PartDesc)-1)
                if PartDesc.substring(len(PartDesc)-1,1) = "," then PartDesc = left(PartDesc,len(PartDesc)-1)
    
                if PartSpec.substring(len(PartSpec)-1,1) = """" then PartSpec = left(PartSpec,len(PartSpec)-1)
                if PartSpec.substring(len(PartSpec)-1,1) = "," then PartSpec = left(PartSpec,len(PartSpec)-1)
    
                if PUsageTemp.substring(len(PUsageTemp)-1,1) = """" then PUsageTemp = left(PUsageTemp,len(PUsageTemp)-1)
                if PUsageTemp.substring(len(PUsageTemp)-1,1) = "," then PUsageTemp = left(PUsageTemp,len(PUsageTemp)-1)
                if trim(PUsageTemp) = "" then PUsage = 0
                if trim(PUsageTemp) <> "" then PUsage = PUsageTemp
    
                if VenCode.substring(len(VenCode)-1,1) = """" then VenCode = left(VenCode,len(VenCode)-1)
                if VenCode.substring(len(VenCode)-1,1) = "," then VenCode = left(VenCode,len(VenCode)-1)
    
                if VenName.substring(len(VenName)-1,1) = """" then VenName = left(VenName,len(VenName)-1)
                if VenName.substring(len(VenName)-1,1) = "," then VenName = left(VenName,len(VenName)-1)
    
                if mfgMPN.substring(len(mfgMPN)-1,1) = """" then mfgMPN = left(mfgMPN,len(mfgMPN)-1)
                if mfgMPN.substring(len(mfgMPN)-1,1) = "," then mfgMPN = left(mfgMPN,len(mfgMPN)-1)
    
                if CurrCode.substring(len(CurrCode)-1,1) = """" then CurrCode = left(CurrCode,len(CurrCode)-1)
                if CurrCode.substring(len(CurrCode)-1,1) = "," then CurrCode = left(CurrCode,len(CurrCode)-1)
    
                if UPTemp.substring(len(UPTemp)-1,1) = """" then UPTemp = left(UPTemp,len(UPTemp)-1)
                if UPTemp.substring(len(UPTemp)-1,1) = "," then UPTemp = left(UPTemp,len(UPTemp)-1)
                if trim(UPTemp) = "" then UP = 0
                if trim(UPTemp) <> "" then UP = UPTemp
    
                if LeadTimeTemp.substring(len(LeadTimeTemp)-1,1) = """" then LeadTimeTemp = left(LeadTimeTemp,len(LeadTimeTemp)-1)
                if LeadTimeTemp.substring(len(LeadTimeTemp)-1,1) = "," then LeadTimeTemp = left(LeadTimeTemp,len(LeadTimeTemp)-1)
                if trim(LeadTimeTemp) = "" then LeadTime = 0
                if trim(LeadTimeTemp) <> "" then LeadTime = LeadTimeTemp
    
                if SPQTemp.substring(len(SPQTemp)-1,1) = """" then SPQTemp = left(SPQTemp,len(SPQTemp)-1)
                if SPQTemp.substring(len(SPQTemp)-1,1) = "," then SPQTemp = left(SPQTemp,len(SPQTemp)-1)
                if trim(SPQTemp) = "" then SPQ = 0
                if trim(SPQTemp) <> "" then SPQ = SPQTemp
    
    
    
                if MOQTemp.substring(len(MOQTemp)-1,1) = """" then MOQTemp = left(MOQTemp,len(MOQTemp)-1)
                if MOQTemp.substring(len(MOQTemp)-1,1) = "," then MOQTemp = left(MOQTemp,len(MOQTemp)-1)
                if trim(MOQTemp) = "" then MOQ = 0
                if trim(MOQTemp) <> "" then MOQ = MOQTemp
    
                ReqCOM.ExecuteNonQuery("Insert into Import_BOM_Quote(Bom_Quote_No,Main_Part,Part_No,Cust_Part_No,Part_Desc,Part_Spec,Ven_Code,Ven_Name,MFG_MPN,Curr_Code,P_Usage,UP,Lead_Time,SPQ,MOQ,Submit_date,Rem) Select '" & trim(cmbBOMQuoteNo.selecteditem.value) & "','" & trim(MainPart) & "','" & trim(PartNo) & "','" & trim(CustPartNo) & "','" & trim(PartDesc) & "','" & trim(PartSpec) & "','" & trim(VenCode) & "','" & trim(VenName) & "','" & trim(MFGMPN) & "','" & trim(CurrCode) & "'," & trim(PUsage) & "," & cdec(UP) & "," & trim(LeadTime) & "," & trim(SPQ) & "," & trim(MOQ) & ",'" & cdate(ReqCOM.FormatDate(txtSubmitDate.text)) & "','" & trim(QuoteRem) & "';")
    
                ReqCOM.ExecuteNonQuery("UPDATE IMPORT_BOM_QUOTE SET DUPLICATE = 'N'")
                ReqCOM.ExecuteNonQuery("update import_bom_quote set duplicate = 'Y' where part_no in (select part_no from import_bom_quote group by part_no having count(*) > 1)")
    
                RemoveDuplicateItem
    
    
            End While
            oRead.Close()
            Response.redirect("ImportBOMQuote1.aspx?BOMQuoteNo=" & Trim(cmbBOMQuoteNo.selecteditem.value) & "&FileName=" & trim(FileControl.PostedFile.FileName))
        Catch err As Exception
            oRead.Close()
            response.WRITE(Err)
        Finally
            'myCommand.Dispose()
            'myConnection.Close()
            'myConnection.Dispose()
        End Try
    End sub
    
    Sub RemoveDuplicateItem()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim SeqNo as long
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand("Select distinct(Part_No) as [PART_NO],sum(p_usage) as [p_usage] from import_bom_quote where duplicate = 'Y' group by part_no", cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            SeqNo = ReqCOM.GetFieldVal("select top 1 Seq_No from import_bom_quote where part_no = '" & trim(drGetFieldVal("Part_No")) & "';","Seq_No")
    
            ReqCOM.ExecuteNonQuery("Update import_bom_quote set P_Usage = " & drGetFieldVal("P_Usage") & ",Duplicate = 'N' where seq_no = " & clng(SeqNo) & ";")
        '    Response.write("Update import_bom_quote set P_Usage = " & drGetFieldVal("P_Usage") & ",Duplicate = 'N' where seq_no = " & clng(SeqNo) & ";")
        loop
    
        ReqCOM.ExecuteNonQuery("Delete from import_bom_quote where duplicate = 'Y';")
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub ValPicFormat(sender As Object, e As ServerValidateEventArgs)
        dim FilePath as string = FileControl.PostedFile.FileName
        Dim FileType as string = FileControl.PostedFile.ContentType
    
        if FilePath.length > 0
            if FileType.tostring = "application/octet-stream" then e.isvalid = true
            if FileType.tostring <> "application/octet-stream" then e.isvalid = false
        End if
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim LineIn as string
        Dim oFile as System.IO.File
        Dim oRead as System.IO.StreamReader
        Dim i as integer
        Dim StrCtrl() as string
        Dim Str,MainPart,PartNo,CustPartNo,PartDesc,PartSpec,VenCode,VenName,mfgMPN,CurrCode,QuoteRem as string
        Dim PUsageTemp,LeadTimeTemp,SPQTemp,MOQTemp,UPTemp as string
        Dim LeadTime,SPQ,MOQ as long
        Dim PUsage,UP as decimal
        Dim TotalLen,LeftStr as integer
    
        oRead = oFile.OpenText(Mappath("") + “\BOMQuote7.csv”)
    
        oRead.Close()
    
    End Sub
    
    Sub cmdHelp_Click(sender As Object, e As EventArgs)
        ShowReport("ERPHelp.aspx?FileName=ImportCustBOM")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ReqCOM.ISDate(trim(txtSubmitDate.text)) = false then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    
    
    
        'Dim DateInput as string
        'Dim DMth,DYr,DDay as string
    
        'DateInput = txtPODate.text
        'if trim(DateInput.length) = 8 then
        '    DDay = DateInput.substring(0,2)
        '    DMth = DateInput.substring(3,2)
        '    DYr = DateInput.substring(6,2)
        '    DateInput = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
        '    if isdate(DateInput) = false then
        '        e.isvalid = false
        '        ValDateInput.ErrorMessage = "You don't seem to have supplied a valid P/O Date"
        '    end if
        'else
        '    e.isvalid = false
        '    ValDateInput.ErrorMessage = "You don't seem to have supplied a valid P/O Date"
        'end if
    
        'DateInput = txtReqDate.text
        'if trim(DateInput.length) = 8 then
        '    DDay = DateInput.substring(0,2)
        '    DMth = DateInput.substring(3,2)
        '    DYr = DateInput.substring(6,2)
        '    DateInput = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
        '    if isdate(DateInput) = false then
        '        e.isvalid = false
        '        ValDateInput.ErrorMessage = "You don't seem to have supplied a valid Customer Req. Date"
        '    end if
        'else
        '    e.isvalid = false
        '    ValDateInput.ErrorMessage = "You don't seem to have supplied a valid Customer Req. Date"
        'end if
    End Sub

</script>
<html>
<head>
    <script language="javascript" src="script.js" type="text/javascript"></script>
    <link href="ibuyspy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">BOM Quote Import</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="Quotation File can only be in Comma Delimited(.csv) format" ControlToValidate="" EnableClientScript="False" ForeColor=" " OnServerValidate="ValPicFormat" Display="Dynamic"></asp:CustomValidator>
                                                    <asp:CustomValidator id="ValDateInput" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="Invalid Date format" EnableClientScript="False" ForeColor=" " OnServerValidate="ValDateInput_ServerValidate" Display="Dynamic"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 80%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">BOM Quote No</asp:Label></td>
                                                                <td width="70%">
                                                                    <p align="left">
                                                                        <asp:DropDownList id="cmbBOMQuoteNo" runat="server" Width="258px" CssClass="OutputText"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Date Submitted (dd/MM/yy)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSubmitDate" runat="server" Width="151px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Quotation File</asp:Label></td>
                                                                <td>
                                                                    <input class="OutputText" id="fileControl" style="WIDTH: 80%; HEIGHT: 20px" type="file" size="22" runat="server" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdImportTransData" onclick="cmdImportTransData_Click" runat="server" Width="99px" CssClass="OutputText" Text="GO"></asp:Button>
                                                                        &nbsp;<asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Button" CausesValidation="False" Visible="False"></asp:Button>
                                                                        &nbsp;<asp:Button id="cmdHelp" onclick="cmdHelp_Click" runat="server" Width="99px" CssClass="OutputText" Text="Help File" CausesValidation="False"></asp:Button>
                                                                    </div>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
        </p>
        <!-- Insert content here -->
    </form>
</body>
</html>
