<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Dim MRPNo,PRNoFrom,PRNo,PRNoTo,CurrVendor,Strpr1 as string
         Dim CurrUP as decimal
    
         Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
             if page.ispostback = false then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                lblLastMRPRun.text = ReqCOM.GetFieldVal("select top 1 'Last MRP Explosion as at ' + CONVERT(varchar(20), end_Date, 13) + ' (MRP No : ' + cast(MRP_No as nvarchar(20)) + ')' as [LastMRP] from mrp_history_m order by seq_no desc","LastMRP")
                lblCriteria.text = trim(request.params("BuyerCode")) & " : For Commodity " & trim(request.params("PartFrom")) & " and " & trim(Request.params("PartTo"))
            End if
         End Sub
    
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
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             Response.redirect("Default.aspx")
         End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
    
        End Sub
    
        Sub LoopPartNoForPRAdj(PRNo as string)
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
    
            ReqCOM.ExecuteNonQuery("Truncate table PR_QTY_ADJ_TEMP")
            ReqCOM.ExecuteNonQuery("Insert into PR_QTY_ADJ_TEMP select part_no,qty_to_buy,seq_no,(select sum(pr_qty) from pr1_d where pr1_d.seq_no <= pr1.seq_no and pr1_d.part_no = pr1.part_no) as [RUNNING_TOTAL] from pr1_d pr1 where pr1.pr_no = '" & trim(PRNo) & "';")
            ReqCOM.ExecuteNonQuery("Update PR1_D set PR1_D.RUNNING_TOTAL=PR_QTY_ADJ_TEMP.running_total from PR1_D,PR_QTY_ADJ_TEMP where PR1_D.seq_no = PR_QTY_ADJ_TEMP.ref_seq_no")
        End sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub cmdYes_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim cnnGetFieldVal As SqlConnection
            Dim drGetFieldVal As SqlDataReader
            Dim myCommand As SqlCommand
    
            MRPNo = ReqCOM.GetFieldVal("Select Top 1 MRP_NO as [MrpNo] from MRP_M order by mrp_no desc", "MRPNo")
            PRNoFrom = ReqCOM.GetFieldVal("select top 1 PR_No from Main","PR_No")
            PRNo = PRNoFrom
    
            ReqCOM.ExecuteNonQuery ("Update MRP_D_Net set post = 'N'")
            ReqCOM.ExecuteNonQuery ("Update MRP_D_Net set post = 'Y' where type <> 'F' and lead_time is not null and on_hold = 0 and source = 'P' and VEN_CODE IS NOT NULL and part_no in (Select Part_No from Part_Master where Buyer_Code = '" & trim(request.params("BuyerCode")) & "' and part_no between '" & trim(request.params("PartFrom")) & "' and '" & trim(request.params("PartTo")) & "')")
    
            cnnGetFieldVal = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            cnnGetFieldVal.Open()
            myCommand = New SqlCommand("select distinct(Buyer_Code) as [BuyerCode] from MRP_D_Net where POST = 'Y' group by Buyer_Code", cnnGetFieldVal )
            drGetFieldVal = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
             do while drGetFieldVal.read
                 PRNoTo = ReqCOM.GetDocumentNo("PR_No")
                 ReqCOM.ExecuteNonQuery ("Insert into PR1_M(PR_NO,MRP_NO,STATUS,SOURCE,BUYER_CODE) Select '" & Trim(PRNoTo) & "'," & MRPNo & ",'OPEN','MRP','" & Trim(drGetFieldVal("BuyerCode")) & "';")
                 ReqCOM.ExecuteNonQuery ("insert into PR1_D(Part_No,PR_QTY,Sch_Days,PR_NO,MRP_NO,BOM_DATE) select distinct(Part_No),sum(net_req_qty-On_Hold),Max(Sch_Days)," & PRNoTo & "," & MRPNo & ",Min(ETA_DATE) from MRP_D_Net where POST = 'Y' and buyer_code = '" & Trim(drGetFieldVal("BuyerCode")) & "' group by month(ETA_DATE),part_no order by part_no asc")
                 LoopPartNoForPRAdj(PRNoTo)
                 ReqCOM.ExecuteNonQuery ("Update main set pr_no = pr_no + 1")
             loop
    
             myCommand.dispose()
             drGetFieldVal.close()
             cnnGetFieldVal.Close()
             cnnGetFieldVal.Dispose()
    
             ReqCOM.ExecuteNonQuery ("Update PR1_D set pr1_d.ven_Code = part_source.ven_code,pr1_d.MOQ = part_source.min_order_qty,pr1_d.spq = part_source.std_pack_qty from pr1_d,part_source where pr1_d.part_no = part_source.part_no and part_source.ven_seq = 1")
             ReqCOM.ExecuteNonQuery ("Truncate Table MRP_Part_Summary")
    
             ReqCOM.ExecuteNonQuery ("Insert Into MRP_PART_SUMMARY(Part_No,PR_QTY,MOQ,SPQ) Select Distinct(Part_No),Sum(PR_Qty),MOQ,SPQ from PR1_D Group By Part_No,MOQ,SPQ")
             ReqCOM.ExecuteNonQuery ("Update MRP_Part_Summary set Max_Qty = SPQ * ceiling(PR_Qty / SPQ)")
             ReqCOM.ExecuteNonQuery ("Update PR1_D set Qty_To_Buy = SPQ * ceiling(PR_Qty / SPQ)")
             ReqCOM.ExecuteNonQuery ("truncate table MRP_FIRST_SOURCE_DET")
             ReqCOM.ExecuteNonQuery ("Insert into MRP_FIRST_SOURCE_DET(Part_No,Ven_Code,UP) select Part_No,Ven_Code,UP from Part_Source where ven_seq = 1 and part_no in (Select distinct(part_no) from mrp_part_summary)")
    
             ReqCOM.ExecuteNonQuery ("Update PR1_D set pr1_d.ven_code=mrp_first_source_det.ven_code,pr1_d.up=mrp_first_source_det.up from pr1_d,mrp_first_source_det where pr1_d.part_no = mrp_first_source_det.part_no")
             ReqCOM.ExecuteNonQuery ("Update pr1_d set pr1_d.spq = part_source.std_pack_qty,pr1_d.moq = part_source.min_order_qty from pr1_d,part_source where pr1_d.part_no = part_source.part_no and pr1_d.part_no = part_source.part_no and part_source.ven_seq = 1")
             ReqCOM.ExecuteNonQuery ("Update PR1_D set SCH_DAYS = 0 where sch_days is null")
             ReqCOM.ExecuteNonQuery ("Update PR1_D set Process_days = 5  where MRP_No = " & MRPNo & ";")
             ReqCOM.ExecuteNonQuery ("Update PR1_D set PR1_D.Lead_Time = PS.Lead_Time * 7 from Part_Source PS,PR1_D where PR1_D.Ven_Code = PS.Ven_Code and PR1_D.Part_No = PS.Part_No and MRP_No = " & MRPNo & ";")
             ReqCOM.ExecuteNonQuery ("Update PR1_D set REQ_Date = BOM_Date where MRP_No = " & MRPNo & ";")
             ReqCOM.ExecuteNonQuery ("Update PR1_D set PR_Date = Req_Date - Lead_Time,Variance = QTY_TO_BUY - PR_QTY where MRP_No = " & MRPNo & ";")
             ReqCOM.ExecuteNonQuery ("Update PR1_M set TO_PURC = 'YES' where MRP_NO = " & MRPNo & ";")
             ReqCOM.ExecuteNonQuery ("Update Main set PR_NO = PR_NO + 1")
    
             ReqCOM.ExecuteNonQuery("update pr1_d set calculated_qty = moq where calculated_qty < moq and pr_no = '" & trim(PRNoTo) & "';")
    
             ReqCOM.ExecuteNonQuery ("update PR1_D set calculated_qty = qty_to_buy")
             ReqCOM.ExecuteNonQuery ("Delete from MRP_D_Net where post = 'Y'")
             ShowAlert ("Selected Parts has been exploded to P/R.")
             redirectPage("MRPPRExplosion.aspx")
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        Response.redirect("MRPPRExplosion.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <div id="dek">
    </div>
    <script type="text/javascript">

    Xoffset=-60;
    Yoffset= 20;
    var old,skn,iex=(document.all),yyy=-1000;
    var ns4=document.layers
    var ns6=document.getElementById&&!document.all
    var ie4=document.all

    if (ns4)
        skn=document.dek
    else if (ns6)
        skn=document.getElementById("dek").style
    else if (ie4)
        skn=document.all.dek.style

    if(ns4)document.captureEvents(Event.MOUSEMOVE);
    else
    {
        skn.visibility="visible"
        skn.display="none"
    }
    document.onmousemove=get_mouse;

    function popup(msg,bak)
    {
        var content="<TABLE  WIDTH=150 BORDER=1 BORDERCOLOR=black CELLPADDING=2 CELLSPACING=0 "+
        "BGCOLOR="+bak+"><TD ALIGN=center><FONT COLOR=black SIZE=2>"+msg+"</FONT></TD></TABLE>";
        yyy=Yoffset;
        if(ns4){skn.document.write(content);skn.document.close();skn.visibility="visible"}
        if(ns6){document.getElementById("dek").innerHTML=content;skn.display=''}
        if(ie4){document.all("dek").innerHTML=content;skn.display=''}
    }

    function get_mouse(e)
    {
        var x=(ns4||ns6)?e.pageX:event.x+document.body.scrollLeft;
        skn.left=x+Xoffset;
        var y=(ns4||ns6)?e.pageY:event.y+document.body.scrollTop;
        skn.top=y+yyy;
    }

    function kill()
    {
        yyy=-1000;
        if(ns4){skn.visibility="hidden";}
        else if (ns6||ie4)
        skn.display="none"
    }
</script>
    <form runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MRP
                                - P/R EXPLOSION</asp:Label><asp:Label id="lblLastMRPRun" runat="server" width="100%" cssclass="SectionHeader"></asp:Label>
                            </div>
                            <p>
                            </p>
                            <div align="center">&nbsp;<asp:Label id="Label1" runat="server">Parts will be submitted
                                based on the criteria as stated below.</asp:Label> 
                            </div>
                            <div align="center"><asp:Label id="lblCriteria" runat="server"></asp:Label>
                            </div>
                            <p align="center">
                                <asp:Label id="Label2" runat="server">You will not be able to undo the changes after
                                the selected parts have been submitted.</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="Label4" runat="server">Are you sure u want to proceed ?</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 9px" width="50%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="right">
                                                    <asp:Button id="cmdYes" onclick="cmdYes_Click" runat="server" Text="Yes" Width="57px"></asp:Button>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Text="No" Width="57px"></asp:Button>
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
    </form>
</body>
</html>
