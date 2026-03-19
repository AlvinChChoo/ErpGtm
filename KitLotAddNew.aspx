<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim rs as SQLDataReader
    
             if page.isPostBack = false then
                 ''rs = ReqCom.ExeDataReader("Select s.Minor_acc_rej,s.Major_acc_rej,s.Minor_SS,s.Major_SS,s.Rec_qty,s.purc_Disposition,s.action_taken,s.def_cause,s.def_desc,s.App1_By,s.app1_date,s.app2_by,s.app2_date,s.del_date,s.create_by,s.create_date,s.Def_Qty,s.Def_Pctg,b.u_id,p.part_desc,p.part_no,v.Ven_Name,v.Contact_Person,S.Scar_No,m.inv_no,m.do_no,m.mif_no from Scar S,mif_m M,vendor v,part_master p,buyer b where b.buyer_code = p.buyer_code and p.part_No = s.part_no and m.ven_code = v.ven_code and s.mif_no = m.mif_no and s.Seq_No = " & request.params("ID") & ";")
                 'rs = ReqCom.ExeDataReader("Select * from kit_lot where seq_no = " & request.params("ID") & ";")
    
                 'do while rs.read
                 '    lblKitLotNo.text = rs("Kit_Lot_No").tostring
                 '    lblStatus.text = rs("Kit_Lot_Status").tostring
                 'loop
             End if
         End Sub
    
         Sub cmdGo_Click(sender As Object, e As EventArgs)
    
         End Sub
    
         Sub cmdSearchLot_Click(sender As Object, e As EventArgs)
             Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
             Dissql ("Select distinct(Lot_No) as [Lot_No] from So_model_m where lot_no like '%" & trim(txtSearchLot.text) & "%'","Lot_No","Lot_No",cmbSearchLot)
    
             if cmbSearchLot.selectedindex <> -1 then
                 Dissql ("Select distinct(P_Level) as [PLevel] from part_allocation where lot_no = '" & trim(cmbSearchLot.selecteditem.value) & "';","PLevel","PLevel",cmbSearchLevel)
                 lblModelNo.text = ReqCOM.GetFieldVal("Select top 1 Model_No from SO_Model_M where Lot_No = '" & trim(cmbSearchLot.selecteditem.value) & "';","Model_No")
                 lblModelDesc.text = ReqCOm.GetFieldVal("Select top 1 Model_Desc from Model_Master where Model_Code = '" & trim(lblmodelNo.text) & "';","Model_Desc")
                 lblLotSize.text = ReqCom.GetFieldVal("Select top 1 Order_Qty from SO_Model_M where Lot_No = '" & trim(cmbSearchLot.selecteditem.value) & "';","Order_Qty")
                 txtSearchLot.text = "-- Search --"
             else if cmbSearchLot.selectedindex = -1 then
                 txtSearchLot.text = "-- Search --"
                 ShowAlert("Invalid Lot No selected.")
             End if
    
             '''''''''''''''''''''''''''''''''''''
    
    
             'Dim PartDesc as string
             'Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
             'cmbSearchLot.items.clear
    
             'Dissql ("Select distinct(Part_No),Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master where Part_No in (Select Part_no from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No like '%" & trim(txtSearchPart.text) & "%' and Revision = " & cdec(lblRevNo.text) & ")","Part_No","Desc",cmbPartNo)
    
             'if cmbPartNo.selectedIndex = 0 then
             '    lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
             '    lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
             '    lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","M_Part_No")
             '    txtSearchPart.text = "-- Search --"
             '    Dissql ("Select P_Level from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Level","P_Level",cmbLevel)
             'else
             '    txtSearchPart.text = "-- Search --"
             '    lblPartSpec.text = ""
             '    lblPartDesc.text = ""
             '    lblMfgPartNo.text = ""
             '    ShowAlert("invalid Part No selected.")
             'end if
    
             'if cmbLevel.selectedIndex = 0 then
             '    lblUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & cdec(lblRevNo.text) & " and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","P_Usage")
             '    lblLocation.text = ReqCOM.GetFieldVal("Select P_Location from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & cdec(lblRevNo.text) & " and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","P_Location")
             'else
             '    lblLocation.text = ""
             '    lblUsage.text = ""
             'End if
         End Sub
    
         Sub ShowAlert(Msg as string)
               Dim strScript as string
               strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
            End sub
    
         SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
         Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
         Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
         with obj
             .DataSource = ResExeDataReader
             .DataValueField = FValue
             .DataTextField = FText
             .DataBind()
         end with
         ResExeDataReader.close()
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim KitLotNo as string = ReqCOM.GetDocumentNo("Kit_Lot_No")
            Dim DateToIssue as date = txtDateToIssue.text
    
            ReqCOM.ExecuteNonQuery("Insert into KIT_LOT(KIT_LOT_NO,LOT_NO,P_LEVEL,REQ_QTY,DATE_TO_ISSUE) select '" & trim(KitLotNo) & "','" & trim(cmbSearchLot.selecteditem.value) & "','" & trim(cmbSearchLevel.selecteditem.value) & "'," & txtReqQty.text & ",'" & cdate(DateToIssue) & "';")
            ReqCOM.ExecuteNonQuery("Update Main set Kit_Lot_No = Kit_Lot_No + 1")
            'Reponse.redirect("KitLotDet.aspx?ID=" & ReqCom.GetFieldVal("Select Seq_No from Issuing_M where Issuing_No = '" & trim() & "';","Seq_No"))
        end if
    End Sub
    
    Sub cmbSearchLot_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dissql ("Select distinct(P_Level) as [PLevel] from part_allocation where lot_no = '" & trim(cmbSearchLot.selecteditem.value) & "';","PLevel","PLevel",cmbSearchLevel)
        lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Model_M where Lot_No = '" & trim(cmbSearchLot.selecteditem.value) & "';","Model_No")
        lblModelDesc.text = ReqCOm.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblmodelNo.text) & "';","Model_Desc")
        'txtSearchLot.text = "-- Search --"
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("KitLot.aspx")
    End Sub
    
    Sub ValDuplicateLotNo(sender As Object, e As ServerValidateEventArgs)
    
        'txtDateToIssue
        Dim DateInput as string = trim(txtDateToIssue.text)
        Dim DMth,DYr,DDay as string
        Dim DateToIssue as string
    'response.write(DateInput.length)
    
        if DateInput.length = 6 then
            DDay = DateInput.substring(0,2)
            DMth = DateInput.substring(2,2)
            DYr = DateInput.substring(4,2)
            DateToIssue = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
        elseif trim(DateInput.length) = 8 then
            DDay = DateInput.substring(0,2)
            DMth = DateInput.substring(3,2)
            DYr = DateInput.substring(6,2)
            DateToIssue = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
        else
            e.isvalid = false
            Exit sub
        end if
    
        if isdate(DateToIssue) = false then
            e.isvalid =false
            Exit sub
        Else
            txtDateToIssue.text = DateToIssue
        end if
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">KIT LOT MATERIAL
                                FORM</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="DuplicateLotNo" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Date to Issue." Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="ValDuplicateLotNo"></asp:CustomValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label1" runat="server" cssclass="LabelNormal">Ref
                                                                        No</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td width="70%">
                                                                    <asp:Label id="lblKitLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="100%">Lot
                                                                            No</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearchLot" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchLot)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdSearchLot" onclick="cmdSearchLot_Click" runat="server" CausesValidation="False" Text="GO" Height="20px"></asp:Button>
                                                                    &nbsp;<asp:DropDownList id="cmbSearchLot" runat="server" Width="260px" CssClass="OutputText" autopostback="true" OnSelectedIndexChanged="cmbSearchLot_SelectedIndexChanged"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="100%">Level</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbSearchLevel" runat="server" Width="262px" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="100%">Request
                                                                        Qty.</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox id="txtReqQty" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="100%">Date to
                                                                    issue (dd/mm/yy)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDateToIssue" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Model No/Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp; <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="100%">Lot Size</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLotSize" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">Prod.
                                                                            By/Date</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="100%">PCMC
                                                                        By/Date</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="1">
                                                                    <div align="left"><asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">Status</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblStatus" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="89px" Text="Save"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="93px" Text="Cancel"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
