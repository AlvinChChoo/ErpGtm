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
            cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure to submit this MIF ?')==false) return false;")
            cmdRemove.attributes.add("onClick","javascript:if(confirm('Are you sure you want to remove this MIF ?')==false) return false;")
    
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            if page.isPostBack = false then
                Dim RsMIF as SQLDataReader = ReqCOM.exeDataReader("Select * from MIF_M where Seq_No = " & Request.params("ID") & ";")
                Dim QtyDel as decimal
                Dim CurrDate as date = format(now,"dd/MMM/yyyy")
    
                Dissql ("Select * from Custom_Exp order by Exp_Desc asc","Exp_Code","Exp_Desc",cmbStationImp)
    
                Do while rsMIF.read
                    lblMIFDate.text = format(cdate(rsMIF("MIF_DATE")),"dd/MMM/yyyy")
                    txtInvNo.text = rsMIF("INV_NO").tostring
                    lblSupplier.text = rsMIF("VEN_CODE").tostring
                    txtRem.text = rsMIF("REM").tostring
                    txtGPBNo.text = rsMIF("GPB_No").tostring
                    txtDONo.text = rsMIF("DO_NO").tostring
                    txtCustomFormNo.text = rsMIF("CUSTOM_FORM_NO").tostring
                    lblMIFNo.text = rsMIF("MIF_NO").tostring
    
                    if isdbnull(rsMIF("App1_Date")) = false then
                        lblApp1By.text = rsMIF("App1_By").tostring
                        lblApp1Date.text = rsMIF("App1_Date").tostring
                        lblApp1Date.text = format(cdate(lblApp1Date.text),"dd/MM/yy")
                    end if
    
                    if isdbnull(rsMIF("App2_Date")) = false then
                        lblApp2By.text = rsMIF("App2_By").tostring
                        lblApp2Date.text = rsMIF("App2_Date").tostring
                        lblApp2Date.text = format(cdate(lblApp2Date.text),"dd/MM/yy")
                    end if
    
                    lblVenname.text = ReqCOm.GetFieldVal("Select Ven_Name from Vendor where Ven_Code = '" & trim(lblSupplier.text) & "';","Ven_Name")
    
                    if trim(lblApp1By.text) <> "" then
                        cmdSubmit.enabled = false
                        cmdAdd.visible = false
                        cmdUpdate.enabled = false
                        cmdRemove.enabled = false
                        lnkChangeSupplier.visible = false
                    else
                        cmdAdd.visible = true
                        cmdSubmit.enabled = true
                        cmdUpdate.enabled = true
                        cmdRemove.enabled = true
                        lnkChangeSupplier.visible = true
                    end if
                Loop
                ProcLoadGridData
                FormatRow()
                if ReqCOM.FuncCheckDuplicate("Select Top 1 Part_No from MIF_D where MIF_No = '" & trim(lblMIFNo.text) & "'","Part_No") = false then cmdSubmit.enabled = false
            end if
        End Sub
    
        sub ProcLoadGridData()
            Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
            Dim StrSql as string = "Select mif.accept_qty,mif.rej_qty,mif.foc_qty,mif.iqc_rem,pm.part_spec,pm.part_desc,mif.part_type,MIF.Date_Receive,MIF.Del_Date,pm.part_desc,MIF.Seq_No,MIF.PO_NO,MIF.PART_NO,MIF.IN_QTY from MIF_D MIF, Part_Master PM where MIF.MIF_NO = '" & trim(lblMIFNo.text) & "' and MIF.Part_No = PM.Part_No order by mif.Part_No asc"
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
            Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            MyList.DataSource = result
            MyList.DataBind()
        end sub
    
        Sub FormatRow()
            Dim InQty,RowSeq As Label
            Dim ImgDelete As ImageButton
            Dim i as integer
    
            For i = 0 To MyList.Items.Count - 1
                ImgDelete = CType(MyList.Items(i).FindControl("ImgDelete"), ImageButton)
                RowSeq = CType(MyList.Items(i).FindControl("RowSeq"), Label)
                InQty = CType(MyList.Items(i).FindControl("InQty"), Label)
    
                if trim(lblApp1By.text) <> "" then ImgDelete.visible = false
                InQty.text = format(clng(InQty.text),"##,##0")
                RowSeq.text = i + 1
            Next
        End Sub
    
        Sub Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
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
    
        Sub cmdCancel_Click(sender As Object, e As EventArgs)
            Response.redirect("MIF.aspx")
        End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            Dim cnnExecuteNonQuery As SqlConnection
            Dim myTrans As SqlTransaction
    
            try
                cnnExecuteNonQuery = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
                cnnExecuteNonQuery.open()
                myTrans = cnnExecuteNonQuery.BeginTransaction()
                Dim myCommand as New SqlCommand("Update MIF_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & cdate(now) & "',MIF_STATUS='PENDING APPROVAL' where mif_no = '" & trim(lblMIFNo.text) & "';", cnnExecuteNonQuery, myTrans)
                myCommand.ExecuteNonQuery
    
                myCommand.CommandText = "Update Part_Master set Part_Master.IQC_BAL = Part_Master.IQC_BAL + MIF_D.IN_QTY, Part_Master.OPEN_PO = Part_Master.OPEN_PO - MIF_D.IN_QTY FROM MIF_D, PART_MASTER WHERE MIF_D.MIF_NO = '" & Trim(lblMIFNo.text) & "' and MIF_D.Part_NO = Part_Master.Part_No"
                myCommand.ExecuteNonQuery
    
                myCommand.CommandText = "Update PO_D set PO_D.In_Qty = PO_D.In_Qty + MIF_D.IN_QTY from MIF_D,PO_D where MIF_D.MIF_NO = '" & trim(lblMIFNo.text) & "' and po_d.po_no = mif_D.po_no and po_d.part_no = mif_D.part_no and po_d.del_date = mif_D.del_date"
                myCommand.ExecuteNonQuery
    
                myCommand.CommandText = "Insert into IQC_Movement(PART_NO,REF,QTY_IN,QTY_OUT,TRANS_TYPE,TRANS_DATE) Select PART_NO,'" & trim(lblMIFNo.text) & "',IN_QTY,0,'IQC','" & now & "' from MIF_D where mif_no = '" & trim(lblMIFNo.text) & "';"
                myCommand.ExecuteNonQuery
    
                myTrans.Commit
    
                ShowAlert("MIF Submitted for IQC approval.")
                redirectPage("MIFDet.aspx?ID=" & Request.params("ID"))
            catch ex as exception
                myTrans.Rollback()
                ShowAlert ("ERP Connection Error\n\nPls contact System Administrator.")
            Finally
                cnnExecuteNonQuery.Close()
            end try
        End Sub
    
        Sub redirectPage(ReturnURL as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
            If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
        End sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub lnkAttachment_Click(sender As Object, e As EventArgs)
            ShowPopup("PopupMIFItem.aspx?VenCode=" & trim(lblSupplier.text) & "&MIFNo=" & lblMIFNo.text)
            redirectPage("MIFDet.aspx?ID=" & Request.params("ID"))
        End Sub
    
        Sub ShowPopup(ReturnURL as string)
            Dim Script As New System.Text.StringBuilder
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
            Script.Append("</script" & ">")
            RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
        End sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Delete from MIF_M where mif_no = '" & trim(lblMIFNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Delete from MIF_D where mif_no = '" & trim(lblMIFNo.text) & "';")
        Response.redirect("MIF.aspx")
    End Sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
        ShowReport("PopupMIFItemEdit.aspx?ID=" & e.commandArgument )
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=600,height=300');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub lnkChangeSupplier_Click(sender As Object, e As EventArgs)
        ShowReport("PopupMIFEditSupplier.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        StrSql = "Update MIF_M set REM = '" & trim(replace(txtRem.text,"'","`")) & "',CUSTOM_FORM_NO = '" & trim(replace(txtCustomFormNo.text,"'","`")) & "',DO_NO = '" & trim(replace(txtDONo.text,"'","`")) & "',INV_NO = '" & trim(replace(txtInvNo.text,"'","`")) & "',GPB_NO = '" & trim(replace(txtGPBNo.text,"'","`")) & "' where mif_no = '" & trim(lblMIFNo.text) & "';"
        ReqCom.ExecuteNonQuery(strSql)
        response.redirect("MIFDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ItemCommand(s as object,e as DataListCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQuery("Delete from MIF_D where Seq_No = " & clng(SeqNo.text) & ";")
        Response.redirect("MIFDet.aspx?ID=" & clng(Request.params("ID")))
    end sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        response.redirect("PopupMIFItem.aspx?VenCode=" & trim(lblSupplier.text) & "&MIFNo=" & lblMIFNo.text)
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">MATERIAL INCOMING
                                FORM (MIF) ITEM</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="cmbStationImp" ErrorMessage="You don't seem to have supplied a valid Station Import." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtGPBNo" ErrorMessage="You don't seem to have supplied a valid GPB No." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtInvNo" ErrorMessage="You don't seem to have supplied a valid Invoice No." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ControlToValidate="txtDONo" ErrorMessage="You don't seem to have supplied a valid DO No." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="txtCustomFormNo" ErrorMessage="You don't seem to have supplied a valid Custom Form No" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label17" runat="server" cssclass="LabelNormal">MIF No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFNo" runat="server" cssclass="OutputText" width="402px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">MIF Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFDate" runat="server" cssclass="OutputText" width="402px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Supplier</asp:Label>&nbsp;<asp:LinkButton id="lnkChangeSupplier" onclick="lnkChangeSupplier_Click" runat="server">Change Supplier</asp:LinkButton>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblSupplier" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="lblVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Receiving Store</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                    -&nbsp; <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">IQC</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                    -&nbsp; <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Station Imp</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbStationImp" runat="server" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">GPB No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtGPBNo" runat="server" Width="353px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Invoice No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtInvNo" runat="server" Width="353px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label15" runat="server" cssclass="LabelNormal">D/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDONo" runat="server" Width="353px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Custom Form No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtCustomFormNo" runat="server" Width="353px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" Width="100%" CssClass="OutputText" TextMode="MultiLine"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
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
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td class="SectionHeader" width="30%">
                                                            </td>
                                                            <td class="SectionHeader" width="40%">
                                                                <div align="center"><asp:Label id="Label12" runat="server" cssclass="SectionHeader" height="10px">MIF
                                                                    DETAILS</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td width="30%">
                                                                <div class="SectionHeader" align="center">
                                                                    <div class="SectionHeader" align="right">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" CssClass="OutputText" Height="26px" Text="ADD NEW" CausesValidation="False"></asp:Button>
                                                                        &nbsp; 
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="sideboxnotop" style="HEIGHT: 13px" width="100%" align="center">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <p>
                                                                    <asp:DataList id="MyList" runat="server" Width="100%" Height="101px" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Font-Names="Arial" Font-Size="XX-Small" OnSelectedIndexChanged="MyList_SelectedIndexChanged">
                                                                        <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                        <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                        <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                        <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                        <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                        <ItemTemplate>
                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td width="18%" bgcolor= "silver">
                                                                                            <asp:Label id="RowSeq" cssclass="ErrorText" visible="true" runat="server" text='1' /> 
                                                                                            <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
                                                                                            <span class="ListLabel">P/O # : </span></td>
                                                                                        <td width="32%">
                                                                                            <asp:Label id="PONo" visible="TRUE" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "po_no") %>' /> 
                                                                                        </td>
                                                                                        <td width="18%" bgcolor= "silver">
                                                                                            <span class="ListLabel">Part Type : </span></td>
                                                                                        <td width="32%">
                                                                                            <asp:Label id="PartType" cssclass= "OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Type") %>' /> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td bgcolor= "silver">
                                                                                            <span class="ListLabel">Part #. : </span></td>
                                                                                        <td>
                                                                                            <asp:Label id="PartNo" cssclass="OutputText" visible="true" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                        </td>
                                                                                        <td bgcolor= "silver">
                                                                                            <span class="ListLabel">Description : </span></td>
                                                                                        <td>
                                                                                            <asp:Label id="PartDesc" cssclass="OutputText" visible="true" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td bgcolor= "silver">
                                                                                            <span class="ListLabel">Specification : </span></td>
                                                                                        <td colspan="3">
                                                                                            <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Spec") %> </span> <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td bgcolor= "silver">
                                                                                            <span class="ListLabel">In Qty</span></td>
                                                                                        <td>
                                                                                            <asp:Label id="InQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "IN_QTY") %>' /> 
                                                                                        </td>
                                                                                        <td bgcolor= "silver">
                                                                                            <span class="ListLabel">Acc Qty/Rej. Qty</span></td>
                                                                                        <td>
                                                                                            <asp:Label id="AcceptQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Accept_Qty") %>' /> / <asp:Label id="RejQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Rej_Qty") %>' /> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td bgcolor= "silver" valign="top">
                                                                                            <span class="ListLabel">IQC Remarks</span></td>
                                                                                        <td colspan="3">
                                                                                            <asp:Textbox id="IQCRem" Readonly="true" TextMode="MultiLine" width="550px" CssClass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "IQC_Rem") %>' />
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                            <br />
                                                                        </ItemTemplate>
                                                                        <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                    </asp:DataList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="80%" CssClass="OutputText" Text="Submit" Enabled="False"></asp:Button>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="80%" CssClass="OutputText" Text="Remove MIF"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="80%" CssClass="OutputText" Text="Update MIF" Enabled="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="80%" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
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
</body>
</html>
