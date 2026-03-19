<%@ Page Language="VB" Debug="true" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then loaddata
    End Sub
    
    Sub LoadData
        Dim strSql as string = "SELECT * FROM SO_MODELS_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblCustCode.text = ResExeDataReader("Cust_Code")
            lblModelNo.text = trim(ResExeDataReader("Model_No").tostring)
            lblModelName.text = ReqExeDataReader.GetFieldVal("Select Model_Desc from model_master where model_code = '" & trim(trim(ResExeDataReader("Model_No").tostring)) & "';","Model_Desc")
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblCustName.text = ReqExeDataReader.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Cust_Name")
            lblOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
            lblDelDate.text = format(ResExeDataReader("req_date"),"dd/MM/yy")
            lblJOQty.text = ResExeDataReader("Job_Order_Qty")
        loop
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    
        End if
    End Sub
    
    Sub Val1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        e.isvalid = true
    
        if trim(txtQty1.text) = "" then txtQty1.text = "0"
        if trim(txtQty2.text) = "" then txtQty2.text = "0"
        if trim(txtQty3.text) = "" then txtQty3.text = "0"
        if trim(txtQty4.text) = "" then txtQty4.text = "0"
        if trim(txtQty5.text) = "" then txtQty5.text = "0"
    
        if isnumeric(txtQty1.text) = false then Val1.ErrorMessage = "Invalid Job Order Qty for item 1.":e.isvalid = false:Exit sub
        if isnumeric(txtQty2.text) = false then Val1.ErrorMessage = "Invalid Job Order Qty for item 2.":e.isvalid = false:Exit sub
        if isnumeric(txtQty3.text) = false then Val1.ErrorMessage = "Invalid Job Order Qty for item 3.":e.isvalid = false:Exit sub
        if isnumeric(txtQty4.text) = false then Val1.ErrorMessage = "Invalid Job Order Qty for item 4.":e.isvalid = false:Exit sub
        if isnumeric(txtQty5.text) = false then Val1.ErrorMessage = "Invalid Job Order Qty for item 5.":e.isvalid = false:Exit sub
    
        if txtQty1.text < 0  then Val1.ErrorMessage = "Invalid Job Order Qty for item 1.":e.isvalid = false:Exit sub
        if txtQty2.text < 0  then Val1.ErrorMessage = "Invalid Job Order Qty for item 2.":e.isvalid = false:Exit sub
        if txtQty3.text < 0  then Val1.ErrorMessage = "Invalid Job Order Qty for item 3.":e.isvalid = false:Exit sub
        if txtQty4.text < 0  then Val1.ErrorMessage = "Invalid Job Order Qty for item 4.":e.isvalid = false:Exit sub
        if txtQty5.text < 0  then Val1.ErrorMessage = "Invalid Job Order Qty for item 5.":e.isvalid = false:Exit sub
    End Sub
    
    Sub cmdBack_Click_1(sender As Object, e As EventArgs)
        Response.redirect("JobOrderDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmbSaveAsNewJO_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim LastJONo as string
            Dim LastJOInt as long
    
            txtJO1.text = ""
            txtJO2.text = ""
            txtJO3.text = ""
            txtJO4.text = ""
            txtJO5.text = ""
    
            if ReqCOM.FuncCheckDuplicate("Select top 1 JO_No from Job_Order_M where lot_no = '" & trim(lblLotNo.text) & "' order by seq_no desc","JO_No") = true then
                LastJONo = ReqCOM.GetFieldVal("Select top 1 JO_No from Job_Order_M where lot_no = '" & trim(lblLotNo.text) & "' order by seq_no desc","JO_No")
                LastJOInt = right(LastJONo,len(LastJONo) - (instr(LastJONo,"-")))
                response.write(LastJOInt)
            else
                LastJOInt = 0
                response.write(LastJOInt)
            end if
    
            if trim(txtQty1.text) <> "0" then LastJOInt = clng(LastJOInt) + 1 :txtJO1.text = trim(lblLotNo.text) + "-" & clng(LastJOInt)
            if trim(txtQty2.text) <> "0" then LastJOInt = clng(LastJOInt) + 1 :txtJO2.text = trim(lblLotNo.text) + "-" & clng(LastJOInt)
            if trim(txtQty3.text) <> "0" then LastJOInt = clng(LastJOInt) + 1 :txtJO3.text = trim(lblLotNo.text) + "-" & clng(LastJOInt)
            if trim(txtQty4.text) <> "0" then LastJOInt = clng(LastJOInt) + 1 :txtJO4.text = trim(lblLotNo.text) + "-" & clng(LastJOInt)
            if trim(txtQty5.text) <> "0" then LastJOInt = clng(LastJOInt) + 1 :txtJO5.text = trim(lblLotNo.text) + "-" & clng(LastJOInt)
            ProcSaveSplitJO
            Response.redirect("PopupSplitLot1.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub ProcSaveSplitJO()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo,JONo As Label
        Dim FOL,ProdQty As textbox
        Dim i As Integer
        Dim FOLInput as date
        Dim DMth,DYr,DDay,DateInput,strSql as string
        Dim TotalJobOrderQty as long
    
        ReqCOM.ExecuteNonQuery("Delete from split_lot_M_temp where U_ID = '" & trim(request.cookies("U_ID").value) & "';")
        if trim(txtQty1.text) <> "0" then
            ReqCOM.ExecuteNonQUery("Insert into job_order_m(lot_no,jo_no,prod_qty,create_by,create_date) select '" & trim(lblLotNo.text) & "','" & trim(txtJO1.text) & "'," & clng(txtQty1.text) & ",'" & trim(request.cookies("U_ID").value) & "','" & trim(now) & "';")
            ReqCOM.ExecuteNonQuery("Insert into job_order_d (PD_Level,Prod_Qty,jo_no) select distinct(SUBSTRING(Level_Code,3,2)) + pd_level,'" & trim(txtQty1.text) & "','" & trim(txtJO1.text) & "' from p_level where level_code in (select distinct(p_level) from BOM_D where model_no = '" & trim(lblModelNo.text) & "')")
        End if
    
        if trim(txtQty2.text) <> "0" then
            ReqCOM.ExecuteNonQUery("Insert into job_order_m(lot_no,jo_no,prod_qty) select '" & trim(lblLotNo.text) & "','" & trim(txtJO2.text) & "'," & clng(txtQty2.text) & ";")
            ReqCOM.ExecuteNonQuery("Insert into job_order_d (PD_Level,Prod_Qty,jo_no) select distinct(SUBSTRING(Level_Code,3,2)) + pd_level,'" & trim(txtQty2.text) & "','" & trim(txtJO2.text) & "' from p_level where level_code in (select distinct(p_level) from BOM_D where model_no = '" & trim(lblModelNo.text) & "')")
        End if
    
        if trim(txtQty3.text) <> "0" then
            ReqCOM.ExecuteNonQUery("Insert into job_order_m(lot_no,jo_no,prod_qty) select '" & trim(lblLotNo.text) & "','" & trim(txtJO3.text) & "'," & clng(txtQty3.text) & ";")
            ReqCOM.ExecuteNonQuery("Insert into job_order_d (PD_Level,Prod_Qty,jo_no) select distinct(SUBSTRING(Level_Code,3,2)) + pd_level,'" & trim(txtQty3.text) & "','" & trim(txtJO3.text) & "' from p_level where level_code in (select distinct(p_level) from BOM_D where model_no = '" & trim(lblModelNo.text) & "')")
        End if
    
        if trim(txtQty4.text) <> "0" then
            ReqCOM.ExecuteNonQUery("Insert into job_order_m(lot_no,jo_no,prod_qty) select '" & trim(lblLotNo.text) & "','" & trim(txtJO4.text) & "'," & clng(txtQty4.text) & ";")
            ReqCOM.ExecuteNonQuery("Insert into job_order_d (PD_Level,Prod_Qty,jo_no) select distinct(SUBSTRING(Level_Code,3,2)) + pd_level,'" & trim(txtQty4.text) & "','" & trim(txtJO4.text) & "' from p_level where level_code in (select distinct(p_level) from BOM_D where model_no = '" & trim(lblModelNo.text) & "')")
        End if
    
        if trim(txtQty5.text) <> "0" then
            ReqCOM.ExecuteNonQUery("Insert into job_order_m(lot_no,jo_no,prod_qty) select '" & trim(lblLotNo.text) & "','" & trim(txtJO5.text) & "'," & clng(txtQty5.text) & ";")
            ReqCOM.ExecuteNonQuery("Insert into job_order_d (PD_Level,Prod_Qty,jo_no) select distinct(SUBSTRING(Level_Code,3,2)) + pd_level,'" & trim(txtQty5.text) & "','" & trim(txtJO5.text) & "' from p_level where level_code in (select distinct(p_level) from BOM_D where model_no = '" & trim(lblModelNo.text) & "')")
        End if
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">JOB ORDER</asp:Label>
                        </p>
                        <p align="center">
                            <asp:CustomValidator id="Val1" runat="server" Width="100%" CssClass="ErrorText" OnServerValidate="Val1_ServerValidate" EnableClientScript="False" ForeColor=" " Display="Dynamic" ErrorMessage=""></asp:CustomValidator>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="50%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td width="30%" bgcolor="silver">
                                                            <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Lot No </asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLotNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Cust. Code / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                            -&nbsp; <asp:Label id="lblCustName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Model No / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                            -&nbsp; <asp:Label id="lblModelName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label30" runat="server" cssclass="LabelNormal">Req. Del. Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDelDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Lot Size</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblOrderQty" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Job Order Exploded</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblJOQty" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <div align="center"><asp:Label id="Label12" runat="server" cssclass="LabelNormal">No
                                                                    Of J/O</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td width="70%" bgcolor="silver">
                                                                <div align="center"><asp:Label id="Label13" runat="server" cssclass="LabelNormal">J/O
                                                                    Qty</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><asp:Label id="Label7" runat="server" cssclass="LabelNormal">1</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtJO1" runat="server" CssClass="OutputText" Visible="False"></asp:TextBox>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtQty1" runat="server" CssClass="OutputText">0</asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><asp:Label id="Label8" runat="server" cssclass="LabelNormal">2</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtJO2" runat="server" CssClass="OutputText" Visible="False"></asp:TextBox>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtQty2" runat="server" CssClass="OutputText">0</asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><asp:Label id="Label9" runat="server" cssclass="LabelNormal">3</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtJO3" runat="server" CssClass="OutputText" Visible="False"></asp:TextBox>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtQty3" runat="server" CssClass="OutputText">0</asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><asp:Label id="Label10" runat="server" cssclass="LabelNormal">4</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtJO4" runat="server" CssClass="OutputText" Visible="False"></asp:TextBox>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtQty4" runat="server" CssClass="OutputText">0</asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><asp:Label id="Label11" runat="server" cssclass="LabelNormal">5</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtJO5" runat="server" CssClass="OutputText" Visible="False"></asp:TextBox>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtQty5" runat="server" CssClass="OutputText">0</asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                    <tbody>
                                                        <tr>
                                                            <td width="50%">
                                                                <p align="left">
                                                                    <asp:Button id="cmbSaveAsNewJO" onclick="cmbSaveAsNewJO_Click" runat="server" Width="80%" Text="Save as New J/O"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click_1" runat="server" Width="80%" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
