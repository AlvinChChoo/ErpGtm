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
                 rs = ReqCom.ExeDataReader("Select s.po_no,m.mif_status,s.app4_rem,s.app4_by,s.app4_date,s.app3_by,s.app3_date,s.Minor_acc_rej,s.Major_acc_rej,s.Minor_SS,s.Major_SS,s.Rec_qty,s.purc_Disposition,s.action_taken,s.def_cause,s.def_desc,s.App1_By,s.app1_date,s.app2_by,s.app2_date,s.del_date,s.create_by,s.create_date,s.Def_Qty,s.Def_Pctg,b.u_id,p.part_desc,p.part_no,v.Ven_Name,v.Contact_Person,S.Scar_No,m.inv_no,m.do_no,m.mif_no from Scar S,mif_m M,vendor v,part_master p,buyer b where b.buyer_code = p.buyer_code and p.part_No = s.part_no and m.ven_code = v.ven_code and s.mif_no = m.mif_no and s.Seq_No = " & request.params("ID") & ";")
                 do while rs.read
                     lblScarNo.text = rs("Scar_No").tostring
                     lblInvNo.text = rs("Inv_No").tostring
                     lblMIFNo.text = rs("MIF_No").tostring
                     lblDONo.text = rs("DO_No").tostring
                     lblVenName.text = rs("Ven_Name")
                     lblAttn.text = rs("Contact_Person")
                     lblCC.text = rs("u_id")
                     lblPartNo.text = rs("Part_No")
                     lblPartDesc.text = rs("Part_Desc")
                     lblCreateBy.text = rs("Create_By")
                     lblCreateDate.text = format(cdate(rs("Create_Date")),"dd/MMM/yy")
                     lblDefQty.text = rs("Def_Qty") & " Pcs"
                     lblDefPctg.text = rs("Def_Pctg") & " %"
                     lblDelDate.text = format(cdate(rs("Del_Date")),"dd/MMM/yy")
                     if isdbnull(rs("Major_SS")) = false then lblSS1.text = rs("Major_SS")
                     if isdbnull(rs("Minor_SS")) = false then lblSS2.text = rs("Minor_SS")
                     if isdbnull(rs("Major_acc_rej")) = false then lblAccRej1.text = rs("Major_acc_rej")
                     if isdbnull(rs("Minor_acc_rej")) = false then lblAccRej2.text = rs("Minor_acc_rej")
                    lblPONo.text = rs("PO_NO")
    
                    if isdbnull(rs("Purc_Disposition")) = false then
                        if trim(rs("PURC_DISPOSITION")) = "SORT" then rbSort.checked = true
                        if trim(rs("PURC_DISPOSITION")) = "RTV" then rbRTV.checked = true
                    else
                        rbSort.checked = true
                    End if
    
                    txtDefDesc.text = rs("Def_Desc").tostring
                    txtDefCause.text = rs("Def_Cause").tostring
                    txtActionTaken.text = rs("Action_Taken").tostring
                    lblRecQty.text = rs("Rec_qty") & " Pcs"
                    lblApp1By.text = rs("App1_By").tostring
                    if isdbnull(rs("App1_Date")) = false then lblApp1Date.text = format(cdate(rs("App1_Date")),"dd/MMM/yy")
                    lblApp2By.text = rs("App2_By").tostring
                    if isdbnull(rs("App2_Date")) = false then lblApp2Date.text = format(cdate(rs("App2_Date")),"dd/MMM/yy")
    
                    lblApp3By.text = rs("App3_By").tostring
                    if isdbnull(rs("App3_Date")) = false then lblApp3Date.text = format(cdate(rs("App3_Date")),"dd/MMM/yy")
    
                    lblApp4By.text = rs("App4_By").tostring
                    if isdbnull(rs("App4_Date")) = false then lblApp4Date.text = format(cdate(rs("App4_Date")),"dd/MMM/yy")
                    if isdbnull(rs("App4_Rem")) = false then lblApp4Rem.text = rs("App4_Rem").tostring
    
                    lblMIFStatus.text = rs("MIF_Status").tostring
    
                    if isdbnull(rs("App4_By")) = true then
                        cmdSubmit.enabled = true
                        label16.visible = true
                        txtRem.visible = true
                        rbReject.visible = true
                        rbApprove.visible = true
                    elseif isdbnull(rs("App4_By")) = false then
                        cmdSubmit.enabled = false
                        label16.visible = false
                        txtRem.visible = false
                        rbReject.visible = false
                        rbApprove.visible = false
                    end if
                loop
            End if
        End Sub
    
        Sub cmdBack_Click(sender As Object, e As EventArgs)
            response.redirect("SCARApp4.aspx")
        End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                Dim ReqCOM as erp_gtm.erp_gtm = new erp_gtm.erp_gtm
                Dim MIFNo as string
    
                if rbApprove.checked = true then
                    ReqCOM.executeNonQuery("Update SCAR set scar_status = 'APPROVED',App4_By = '" & trim(request.cookies("U_ID").value) & "',App4_Date = '" & cdate(now) & "',App4_Status = 'Y' where scar_no = '" & trim(lblScarNo.text) & "';")
    
                    MIFNo = ReqCOM.GetDocumentNo("MIF_NO")
                    ReqCOM.ExecuteNonQuery("Insert into MIF_M(MIF_NO,VEN_CODE,MIF_DATE,CUSTOM_FORM,GPB_NO,INV_NO,LOCATION,REM,CUSTOM_FORM_NO,DO_NO,CUSTOM_EXP,app1_By,app1_date) select '" & trim(MIFNo) & "',VEN_CODE,MIF_DATE,CUSTOM_FORM,GPB_NO,INV_NO,LOCATION,REM,CUSTOM_FORM_NO,DO_NO,CUSTOM_EXP,'" & trim(request.cookies("U_ID").value) & "','" & cdate(now) & "' from MIF_M where mif_no = '" & trim(lblMIFNo.text) & "';")
                    ReqCOM.ExecuteNonQuery("Insert into MIF_D(MIF_NO,PO_NO,PART_NO,IN_QTY,REM,DEL_DATE,DATE_RECEIVE,REJ_QTY,ACCEPT_QTY,ON_TIME,IQC_CHECK_BY,IQC_CHECK_Date,IQC_REM,PART_TYPE) select '" & trim(MIFNo) & "',PO_NO,PART_NO,IN_QTY,REM,DEL_DATE,DATE_RECEIVE,REJ_QTY,ACCEPT_QTY,ON_TIME,IQC_CHECK_BY,IQC_CHECK_Date,IQC_REM,PART_TYPE from mif_d where mif_no = '" & trim(lblMIFNo.text) & "' and po_no = '" & trim(lblPONo.text) & "' and part_no = '" & trim(lblPartNo.text) & "';")
                    ReqCOM.ExecuteNonQuery("Update Main set MIF_No = MIF_No + 1")
                end if
    
                if rbReject.checked = true then
                    ReqCOM.executeNonQuery("Update SCAR set scar_status = 'REJECTED',App4_By = '" & trim(request.cookies("U_ID").value) & "',App4_Date = '" & cdate(now) & "',App4_Status = 'N' where scar_no = '" & trim(lblScarNo.text) & "';")
                end if
    
                ShowAlert("Selected SCAR has been submitted.")
                redirectPage("SCARApp4Det.aspx?ID=" & Request.params("ID"))
            End if
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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">SUPPLIER CORRECTIVE
                                ACTION REPORT (SCAR)</asp:Label>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 80%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="80%" align="center" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="30%" bgcolor="silver">
                                                <div align="left"><asp:Label id="Label27" runat="server" cssclass="LabelNormal">Ref
                                                    No</asp:Label>
                                                </div>
                                            </td>
                                            <td width="70%">
                                                <asp:Label id="lblScarNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <div align="left"><asp:Label id="Label6" runat="server" width="100%" cssclass="LabelNormal">Supplier</asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <div align="left"><asp:Label id="Label7" runat="server" width="100%" cssclass="LabelNormal">Attn</asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblAttn" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <div align="left"><asp:Label id="Label8" runat="server" width="100%" cssclass="LabelNormal">CC</asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblCC" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label4" runat="server" width="100%" cssclass="LabelNormal">Issued By</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label5" runat="server" width="100%" cssclass="LabelNormal">Verified
                                                By</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <div align="left"><asp:Label id="Label3" runat="server" width="100%" cssclass="LabelNormal">Approved</asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label28" runat="server" width="100%" cssclass="LabelNormal">Purchasing</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver" rowspan="2">
                                                <asp:Label id="Label34" runat="server" width="100%" cssclass="LabelNormal">IQC</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblApp4Rem" runat="server" cssclass="OutputText">-</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Status1" runat="server" width="100%" cssclass="LabelNormal">Status</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblMIFStatus" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="30%">
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label9" runat="server" width="100%" cssclass="LabelNormal">Invoice
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblInvNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label10" runat="server" width="100%" cssclass="LabelNormal">D.O.
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblDONo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label11" runat="server" width="100%" cssclass="LabelNormal">MIF
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblMIFNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <asp:Label id="lblPONo" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                            <td width="25%" colspan="2">
                                                <table style="HEIGHT: 10px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Delivery Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDelDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td width="45%">
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label15" runat="server" width="100%" cssclass="LabelNormal">Part
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblPartno" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label22" runat="server" width="100%" cssclass="LabelNormal">Part Name</asp:Label></td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblPartDesc" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label23" runat="server" width="100%" cssclass="LabelNormal">Model</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="Label31" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table style="HEIGHT: 20px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="30%">
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="left"><asp:Label id="Label12" runat="server" width="100%" cssclass="LabelNormal">Place
                                                                    where reject(s) detected</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="left">
                                                                    <asp:RadioButton id="RadioButton3" runat="server" CssClass="OutputText" Text="IQC Reject"></asp:RadioButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="left">
                                                                    <asp:RadioButton id="RadioButton4" runat="server" CssClass="OutputText" Text="Production Claim"></asp:RadioButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td width="25%" colspan="2">
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Quantity</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblRecQty" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label17" runat="server" cssclass="LabelNormal">PCS Qty</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDefQty" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label24" runat="server" cssclass="LabelNormal">Defective %</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDefPctg" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td width="45%">
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="5">
                                                                <div align="center"><asp:Label id="Label18" runat="server" cssclass="LabelNormal">Sample
                                                                    Size</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblMajor" runat="server" cssclass="LabelNormal">Major : 0.4</asp:Label></td>
                                                            <td>
                                                                <div align="right"><asp:Label id="Label30" runat="server" cssclass="LabelNormal">S/S</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblSS1" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="right"><asp:Label id="Label32" runat="server" cssclass="LabelNormal">Acc/Rej</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblAccRej1" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblMinor" runat="server" cssclass="LabelNormal">Minor : 0.65</asp:Label></td>
                                                            <td>
                                                                <div align="right"><asp:Label id="Label29" runat="server" cssclass="LabelNormal">S/S</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblSS2" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="right"><asp:Label id="Label33" runat="server" cssclass="LabelNormal">Acc/Rej</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblAccRej2" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table style="HEIGHT: 8px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label19" runat="server" width="100%" cssclass="LabelNormal">Defect
                                                                Description</asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtDefDesc" runat="server" CssClass="OutputText" Width="100%" Height="52px" ReadOnly="True"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table style="HEIGHT: 8px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 13px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="60%">
                                                                <asp:Label id="Label25" runat="server" cssclass="LabelNormal">Purchasing Disposition
                                                                :-</asp:Label>&nbsp;&nbsp; 
                                                                <asp:RadioButton id="rbSort" runat="server" Text="Sort/Rework" GroupName="PurcDisp" Enabled="False"></asp:RadioButton>
                                                                &nbsp;&nbsp; 
                                                                <asp:RadioButton id="rbRTV" runat="server" Text="RTV" GroupName="PurcDisp" Enabled="False"></asp:RadioButton>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label26" runat="server" cssclass="LabelNormal">Others (Pls specify)
                                                                :-</asp:Label>&nbsp;&nbsp; 
                                                                <asp:TextBox id="txtOthers" runat="server" Width="535px" ReadOnly="True"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table style="HEIGHT: 8px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table style="HEIGHT: 8px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label20" runat="server" width="100%" cssclass="LabelNormal">Defect
                                                                Cause</asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtDefCause" runat="server" CssClass="OutputText" Width="100%" Height="62px" ReadOnly="True"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table style="HEIGHT: 8px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 48px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label21" runat="server" width="100%" cssclass="LabelNormal">Corrective
                                                                & Preventive Action</asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtActionTaken" runat="server" CssClass="OutputText" Width="100%" Height="56px" ReadOnly="True"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
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
        <p align="right">
            <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                <tbody>
                    <tr>
                        <td width="25%">
                            <asp:Label id="Label16" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                        <td width="55%">
                            <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" Height="56px"></asp:TextBox>
                        </td>
                        <td width="20%">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <asp:RadioButton id="rbApprove" runat="server" CssClass="OutputText" Text="Approve" GroupName="Status"></asp:RadioButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:RadioButton id="rbReject" runat="server" CssClass="OutputText" Text="Reject" GroupName="Status"></asp:RadioButton>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p align="right">
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td width="50%">
                            <p align="left">
                                <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="133px"></asp:Button>
                            </p>
                        </td>
                        <td width="50%">
                            <div align="right">
                                <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="133px" CausesValidation="False"></asp:Button>
                            </div>
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
