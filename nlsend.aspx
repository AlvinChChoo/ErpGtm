<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="iso-8859-1" %>
<%@ Register TagPrefix="ExportTechnologies" Namespace="ExportTechnologies.NetComponents.RichTextEditor" Assembly="RichTextEditor" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ import Namespace="System.IO" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

    void Page_Load()
    {
        if(!IsPostBack)
        {
            lblID.Text = User.Identity.Name;
            lblNLID.Text = Request["nlid"].ToString();
            BindMaillist();
        }
    }
    
    void BindMaillist()
    {
        string connectionString = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt = "select * from maillist where ncid='" + User.Identity.Name + "'";
        SqlConnection conn = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand(conn_stmt, conn);
        cmd.Connection.Open();
        SqlDataReader dr = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        while(dr.Read())
        {
            cblMaillist.Items.Add(dr["mlEmail"].ToString());
        }
        dr.Close();
    }
    
    void Back_Click(object o, CommandEventArgs e)
    {
        Response.Redirect("nlpreview.aspx?nlid=" + lblNLID.Text);
    }
    
    void Refresh_Click(object o, CommandEventArgs e)
    {
        Response.Redirect("nlsend.aspx?nlid=" + Request["nlid"].ToString());
    }
    
    void Preview_Click(object o, CommandEventArgs e)
    {
        string domain = "";
        string email = "";
        string company = "";
    
        string header = "";
        string footer = "";
    
        //Read related nasys client info
        string connectionString = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt = "select * from nasysclient where ncid='" + User.Identity.Name + "'";
        SqlConnection conn = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand(conn_stmt, conn);
        cmd.Connection.Open();
        SqlDataReader dr = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr.Read())
        {
            domain = dr["ncDomain"].ToString();
            email = dr["ncEmail"].ToString();
            company = dr["ncBizName"].ToString();
        }
    
        string connectionString2 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt2 = "select * from newsletter where nlid='" + lblNLID.Text + "'";
        SqlConnection conn2 = new SqlConnection(connectionString2);
        SqlCommand cmd2 = new SqlCommand(conn_stmt2, conn2);
        cmd2.Connection.Open();
        SqlDataReader dr2 = cmd2.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr2.Read())
        {
            header = dr2["Header"].ToString();
            footer = dr2["Footer"].ToString();
        }
    
        //Read newsletter content
        string connectionString1 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt1 = "Select * from nlcontent where nlid='" + lblNLID.Text + "'";
        SqlConnection conn1 = new SqlConnection(connectionString1);
        SqlCommand cmd1 = new SqlCommand(conn_stmt1, conn1);
        cmd1.Connection.Open();
        SqlDataReader dr1 = cmd1.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
    
        //Prepare email body
        string mailbody;
    
        mailbody = "<%@ Page Language='C#' ContentType='text/html' ResponseEncoding='iso-8859-1' %><html><head></head>";
        mailbody += "<body leftmargin='0' background='http://demo.nasyspro.com/newsletter_template/template1/images/box/color1.gif' topmargin='0' marginwidth='0' marginheight='0'>";
        mailbody += "<br /><table bordercolor='#ffffff' cellspacing='0' cellpadding='0' width='652' align='center' border='1'>";
        mailbody += "<tbody><tr><td bgcolor='#cccccc'>";
        mailbody += "<table cellspacing='0' cellpadding='0' width='652' align='center' border='0'>";
        mailbody += "<tbody><tr>";
        mailbody += "<td width='714' background='http://demo.nasyspro.com/newsletter_template/template1/images/gray/color1.gif'>";
        mailbody += "<div align='right'><img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top1/color1.gif' width='158' />";
        mailbody += "<img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top2/color1.gif' width='341' />";
        mailbody += "<img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top3/color1.gif' width='130' />";
        mailbody += "</div></td></tr></tbody></table>";
        mailbody += "<table cellspacing='0' cellpadding='0' width='629' align='center' border='0'>";
        mailbody += "<tbody><tr><td>";
        mailbody += "<img height='18' src='http://demo.nasyspro.com/newsletter_template/template1/images/bar1/color1.gif' width='292' />";
        mailbody += "<img height='18' src='http://demo.nasyspro.com/newsletter_template/template1/images/bar2/color1.gif' width='360' /></td>";
        mailbody += "</tr></tbody></table>";
    
        mailbody += "<table cellspacing='0' cellpadding='6' width='629' align='center' bgcolor='#CCCCCC' border='0'>";
        mailbody += "<tr><td>Newsletter from <a href='http://" + domain + "'>" + company + "</a>: </td></tr><tr><td>";
    
        //Header
        mailbody += "<p>" + header + "</p></td></tr><tr><td>";
    
        mailbody += "<table cellspacing='0' rules='all' border='1' style='width:629px; border-collapse:collapse;'>";
    
    
    
        while (dr1.Read())
        {
            mailbody += "<tr><td align='center' valign='middle' width='140' style='background-color:Black;'>";
            mailbody += "<img src='http://demo.nasyspro.com/private/nlshowinternal.aspx?img=" + dr1["nid"].ToString() + "&nl=" + dr1["nlid"].ToString() + "' border='0' style='width:140px;'>";
            mailbody += "</td><td style='background-color:silver;'>";
            mailbody += "<h3>" + dr1["nlName"].ToString() + "</h3><br>" + dr1["nlDescription"].ToString() + "</td></tr>";
        }
    
    
        mailbody += "</table>";
    
        //Footer
        mailbody += "<br><div align='left'>" + footer + "</div><div align='right'><a href='nlsend.aspx?nlid=";
        mailbody += lblNLID.Text + "'>Back</a></div>";
    
        mailbody += "</td></tr></table>";
    
        mailbody += "<div align='center'><font face='Arial, Helvetica, sans-serif' color='#000000' size='1'><strong>";
        mailbody += "<br />NasysPro - Your online business community is maintained and owned by<br />";
        mailbody += "Nasys Technology Sdn Bhd <a href='mailto:webmaster@nasyspro.com'>webmaster</a> Copyright";
        mailbody += "&#169; 2004 </strong></font></div><br>";
    
    
        mailbody += "</td></tr></tbody></table></body></html>";
    
        Response.Write(mailbody);
        form1.Visible = false;
    }
    
    void Send_Click(object o, CommandEventArgs ea)
    {
        if(User.Identity.Name == "7336060400000083")
        {
            Response.Write("<script language='JavaScript'>");
            Response.Write("alert('Guest users are not allowed to send newsletters.')");
            Response.Write("</" + "script>");
            return;
        }
    
        string sentmail = "Newsletter has been sent to the following email:\\n";
    
        foreach(ListItem li in cblMaillist.Items)
        {
            if(li.Selected)
            {
                PreSendMail(li.Value);
                sentmail += "\\n     - " + li.Value;
            }
        }
    
        bool duplicate = false;
    
        string[] list = txtMail.Text.Split(new Char[] {','});
        for (int i=0;i<list.Length;i++)
        {
            if(list[i] != "")
            {
                duplicate = false;
                foreach(ListItem li in cblMaillist.Items)
                {
                    if(list[i] == li.Text)
                    {
                        duplicate = true;
                    }
                }
    
                if(!duplicate)
                {
                    string connectionString = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                    string conn_stmt = "Insert into maillist(ncID, mlEmail, isreceive) values ('" + User.Identity.Name + "','" + list[i] + "','0')";
                    SqlConnection conn = new SqlConnection(connectionString);
                    SqlCommand cmd = new SqlCommand(conn_stmt, conn);
                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                }
                PreSendMail(list[i]);
                sentmail += "\\n     - " + list[i];
            }
        }
    
        if(chkIndustry.Checked)
        {
            SendToIndustry();
            sentmail += "\\n     - other subindustries";
        }
    
        //inform sender the list of email sent.
        Response.Write("<script language='Javascript'>");
        Response.Write("alert('" + sentmail + "')");
        Response.Write("</" + "script>");
    
        txtMail.Text = "";
        cblMaillist.Items.Clear();
        BindMaillist();
    }
    
    void PreSendMail(string to)
    {
        int isReceive = 0;
    
        string connectionString6 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt6 = "select * from maillist where mlemail='" + to + "' and ncID='" + User.Identity.Name + "'";
        SqlConnection conn6 = new SqlConnection(connectionString6);
        SqlCommand cmd6 = new SqlCommand(conn_stmt6, conn6);
        cmd6.Connection.Open();
        SqlDataReader dr6 = cmd6.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr6.Read())
        {
            isReceive = Convert.ToInt32(dr6["isReceive"]);
        }
        cmd6.Connection.Close();
    
        if(isReceive == 0)
        {
            SendNotice(to);
        }
        else
        {
            SendMail(to);
        }
    }
    
    void SendMail(string to)
    {
        string domain = "";
        string email = "";
        string company = "";
    
        //Read related nasys client info
        string connectionString = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt = "select * from nasysclient where ncid='" + User.Identity.Name + "'";
        SqlConnection conn = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand(conn_stmt, conn);
        cmd.Connection.Open();
        SqlDataReader dr = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr.Read())
        {
            domain = dr["ncDomain"].ToString();
            email = dr["ncEmail"].ToString();
            company = dr["ncBizName"].ToString();
        }
    
        //Read newsletter content
        string connectionString1 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt1 = "Select * from nlcontent where nlid='" + lblNLID.Text + "'";
        SqlConnection conn1 = new SqlConnection(connectionString1);
        SqlCommand cmd1 = new SqlCommand(conn_stmt1, conn1);
        cmd1.Connection.Open();
        SqlDataReader dr1 = cmd1.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
    
        //Prepare email body
        string mailbody;
    
        mailbody = "<%@ Page Language='C#' ContentType='text/html' ResponseEncoding='iso-8859-1' %><html><head></head>";
        mailbody += "<body leftmargin='0' background='http://demo.nasyspro.com/newsletter_template/template1/images/box/color1.gif' topmargin='0' marginwidth='0' marginheight='0'>";
        mailbody += "<br /><table bordercolor='#ffffff' cellspacing='0' cellpadding='0' width='652' align='center' border='1'>";
        mailbody += "<tbody><tr><td bgcolor='#cccccc'>";
        mailbody += "<table cellspacing='0' cellpadding='0' width='652' align='center' border='0'>";
        mailbody += "<tbody><tr>";
        mailbody += "<td width='714' background='http://demo.nasyspro.com/newsletter_template/template1/images/gray/color1.gif'>";
        mailbody += "<div align='right'><img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top1/color1.gif' width='158' />";
        mailbody += "<img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top2/color1.gif' width='341' />";
        mailbody += "<img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top3/color1.gif' width='130' />";
        mailbody += "</div></td></tr></tbody></table>";
        mailbody += "<table cellspacing='0' cellpadding='0' width='629' align='center' border='0'>";
        mailbody += "<tbody><tr><td>";
        mailbody += "<img height='18' src='http://demo.nasyspro.com/newsletter_template/template1/images/bar1/color1.gif' width='292' />";
        mailbody += "<img height='18' src='http://demo.nasyspro.com/newsletter_template/template1/images/bar2/color1.gif' width='360' /></td>";
        mailbody += "</tr></tbody></table>";
    
        mailbody += "<table cellspacing='0' cellpadding='6' width='629' align='center' bgcolor='#CCCCCC' border='0'>";
        mailbody += "<tr><td>Newsletter from <a href='http://" + domain + "'>" + company + "</a>: </td></tr><tr><td>";
    
        mailbody += "<table cellspacing='0' rules='all' border='1' style='width:629px; border-collapse:collapse;'>";
    
        while (dr1.Read())
        {
            mailbody += "<tr><td align='center' valign='middle' width='140' style='background-color:Black;'>";
            mailbody += "<img src='http://demo.nasyspro.com/private/nlshowinternal.aspx?img=" + dr1["nid"].ToString() + "&nl=" + dr1["nlid"].ToString() + "' border='0' style='width:140px;'>";
            mailbody += "</td><td style='background-color:silver;'>";
            mailbody += "<h3>" + dr1["nlName"].ToString() + "</h3><br>" + dr1["nlDescription"].ToString() + "</td></tr>";
        }
    
    
        mailbody += "</table></td></tr></table>";
    
    
    
        mailbody += "<div align='center'><font face='Arial, Helvetica, sans-serif' color='#000000' size='1'><strong>";
        mailbody += "<br />NasysPro - Your online business community is maintained and owned by<br />";
        mailbody += "Nasys Technology Sdn Bhd <a href='mailto:webmaster@nasyspro.com'>webmaster</a> Copyright";
        mailbody += "&#169; 2004 </strong></font></div><br>";
    
    
        mailbody += "</td></tr></tbody></table></body></html>";
    
        MailMessage mail = new MailMessage();
        mail.To = to;
        mail.From = email;
        mail.Subject = "Nasyspro Newsletter";
        mail.BodyFormat = MailFormat.Html;
        mail.Body = mailbody;
    
        //Make sure "'" can be inserted into SQL server
        mailbody = mailbody.Replace("'","''");
    
        string connectionString8 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt8 = "select count(*) as counter from view_letter where nlid='" + lblNLID.Text + "'";
        SqlConnection conn8 = new SqlConnection(connectionString8);
        SqlCommand cmd8 = new SqlCommand(conn_stmt8, conn8);
        cmd8.Connection.Open();
        SqlDataReader dr8 = cmd8.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr8.Read())
        {
            //Check if related newsletter have been saved to database,
            //if not exist (counter = 0), save it
            //else update it
            if(Convert.ToInt32(dr8["counter"]) == 0)
            {
                string connectionString2 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                string conn_stmt2 = "insert into view_letter(details,nlid) values ('" + mailbody + "','" + lblNLID.Text + "')";
                SqlConnection conn2 = new SqlConnection(connectionString2);
                SqlCommand cmd2 = new SqlCommand(conn_stmt2, conn2);
                cmd2.Connection.Open();
                cmd2.ExecuteNonQuery();
                cmd2.Connection.Close();
            }
            else
            {
                string connectionString00 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                string conn_stmt00 = "update view_letter set details = '" + mailbody + "' where nlid='" + lblNLID.Text + "'";
                SqlConnection conn00 = new SqlConnection(connectionString00);
                SqlCommand cmd00 = new SqlCommand(conn_stmt00, conn00);
                cmd00.Connection.Open();
                cmd00.ExecuteNonQuery();
                cmd00.Connection.Close();
            }
        }
    
        //get id for further usage on newsletter
        string vlid = "";
    
        string connectionString7 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt7 = "select * from view_letter where nlid='" + lblNLID.Text + "'";
        SqlConnection conn7 = new SqlConnection(connectionString7);
        SqlCommand cmd7 = new SqlCommand(conn_stmt7, conn7);
        cmd7.Connection.Open();
        SqlDataReader dr7 = cmd7.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr7.Read())
        {
            vlid = dr7["id"].ToString();
        }
    
        string mailbody2 = "<br>If this newsletter cannot be displayed properly, you can use the following methods to view the newsletter:";
              mailbody2 += "<ol><li>Click on the hyperlink below to directly view the newsletter:<br>";
              mailbody2 += "<a href='http://demo.nasyspro.com/newsletter_template/template1/view_letter1.aspx?id=" + vlid + "'>";
              mailbody2 += "http://demo.nasyspro.com/newsletter_template/template1/view_letter1.aspx?id=" + vlid + "</a>";
              mailbody2 += "</li><p>or</p><li>Copy the below URL and paste it to the address bar on your browser:<br>";
              mailbody2 += "http://demo.nasyspro.com/newsletter_template/template1/view_letter1.aspx?id=" + vlid;
              mailbody2 += "</li><p>or</p><li>Go to ";
              mailbody2 += "<a href='http://demo.nasyspro.com/newsletter_template/template1/view_newsletter.aspx'>";
              mailbody2 += "http://demo.nasyspro.com/newsletter_template/template1/view_newsletter.aspx</a>, ";
              mailbody2 += "<br>type &quot;" + vlid + "&quot; (without the double quote) in the textbox on the site, then click on &quot;GO&quot; button.";
              mailbody2 += "</li></ol><p>";
              mailbody2 += "<i>Note: You receive this email because you have previously subscribed to our newsletter.";
              mailbody2 += "If you do not wish to receive further newsletter from us, you can ";
              mailbody2 += "<a href='http://demo.nasyspro.com/newsletterset/unsubscribe.aspx?";
              mailbody2 += "ml=" + to + "&ncid=" + User.Identity.Name + "'>";
              mailbody2 += "unsubscribe</a>.</i></p>";
        mail.Body += mailbody2;
        SmtpMail.Send(mail);
    }
    
    void SendNotice(string to)
    {
        string company = "";
        string from = "";
        string domain = "";
    
        string noticeBody = "";
    
        string connectionString = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt = "Select * from nasysclient where ncID='" + User.Identity.Name + "'";
        SqlConnection conn = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand(conn_stmt, conn);
        cmd.Connection.Open();
        SqlDataReader dr = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr.Read())
        {
            company = dr["ncBizName"].ToString();
            from = dr["ncEmail"].ToString();
            domain = dr["ncDomain"].ToString();
        }
    
        noticeBody += "<html><head></head><body><a href='http://www.nasyspro.com'>";
        noticeBody += "<img src='http://www.nasyspro.com/nasyspro_title_blue_long.jpg'";
        noticeBody += " width='600' height='59' border='0'></a><br/><br/>";
        noticeBody += "Dear " + to + ",<br><br><br><a href='http://" + domain + "'>";
        noticeBody += company + "</a> would like to send you a newsletter.";
        noticeBody += "<br><br>Would you accept to receive this newsletter? ";
        noticeBody += "If you want, please click on <a href='http://demo.nasyspro.com/newsletterset/subscribe.aspx?";
        noticeBody += "nlid=" + lblNLID.Text + "&ncid=" + User.Identity.Name + "&ml=" + to + "'>";
        noticeBody += "subscribe</a>.<br><br>";
        noticeBody += "If you do not want to receive our newsletter, please click on ";
        noticeBody += "<a href='http://demo.nasyspro.com/newsletterset/unsubscribe.aspx?";
        noticeBody += "ncid=" + User.Identity.Name + "&ml=" + to + "'>";
        noticeBody += "ignore</a>.<br><br>";
        noticeBody += "Yours sincerely,<br>The management<br><br><br>";
        noticeBody += "<i>Note: We will not gather any information from you. You can unsubscribe the newsletter at a later time as well.</i>";
    
        MailMessage notice = new MailMessage();
        notice.To = to;
        notice.From = from;
        notice.Subject = "Nasyspro Newsletter Invitation";
        notice.BodyFormat = MailFormat.Html;
        notice.Body = noticeBody;
    
        SmtpMail.Send(notice);
    
        noticeBody = noticeBody.Replace("'","''");
    
        string connectionString1 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt1 = "select count(*) as counter from view_letter where nlid='" + lblNLID.Text + "'";
        SqlConnection conn1 = new SqlConnection(connectionString1);
        SqlCommand cmd1 = new SqlCommand(conn_stmt1, conn1);
        cmd1.Connection.Open();
        SqlDataReader dr1 = cmd1.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr1.Read())
        {
            if(Convert.ToInt32(dr1["counter"]) == 0)
            {
                string connectionString2 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                string conn_stmt2 = "insert into view_letter(details,nlid) values('" + noticeBody + "','" + lblNLID.Text + "')";
                SqlConnection conn2 = new SqlConnection(connectionString2);
                SqlCommand cmd2 = new SqlCommand(conn_stmt2, conn2);
                cmd2.Connection.Open();
                cmd2.ExecuteNonQuery();
                cmd2.Connection.Close();
            }
            else
            {
                string connectionString00 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                string conn_stmt00 = "update view_letter set details='" + noticeBody + "' where nlid='" + lblNLID.Text + "'";
                SqlConnection conn00 = new SqlConnection(connectionString00);
                SqlCommand cmd00 = new SqlCommand(conn_stmt00, conn00);
                cmd00.Connection.Open();
                cmd00.ExecuteNonQuery();
                cmd00.Connection.Close();
            }
        }
    }
    
    void SendToIndustry()
    {
        //initialization
        string company = "";    //company name of sender
        string domain = "";     //domain name of sender
        string email = "";      //company email of sender
        string[] dontSend = null;   //array to store subID that "DO NOT SEND"
        string[] receive = null;    //array to store subID that "WANT TO RECEIVE"
        string industryID = "";     //sender's primary industry code
        string industryName = "";   //sender's primary industry name
        string[] subid2send = new string[100];  //array to store subid that "WANT TO SEND"
        int index = 0;  //counter to support "subid2send"
        int counter = 0;
    
        //retrieve sender's required info
        string connectionString = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt = "select * from nasysclient where ncid='" + User.Identity.Name + "'";
        SqlConnection conn = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand(conn_stmt, conn);
        cmd.Connection.Open();
        SqlDataReader dr = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        if(dr.Read())
        {
            company = dr["ncBizName"].ToString();
            domain = dr["ncDomain"].ToString();
            email = dr["ncEmail"].ToString();
            string[] temp = dr["ncExclude"].ToString().Split(new char[] {':'});
            dontSend = temp[0].Split(new char[] {','});
            receive = temp[1].Split(new char[] {','});
            industryID = dr["subID1"].ToString();
        }
        dr.Close();
    
        for(int a=0; a<dontSend.Length; a++)
        {
            dontSend[a] = dontSend[a].Replace("'","");
        }
        for(int a=0; a<receive.Length; a++)
        {
            receive[a] = receive[a].Replace("'","");
        }
    
        //Prepare subid2send
        string connectionString1 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
        string conn_stmt1 = "select * from subindustry";
        SqlConnection conn1 = new SqlConnection(connectionString1);
        SqlCommand cmd1 = new SqlCommand(conn_stmt1, conn1);
        cmd1.Connection.Open();
        SqlDataReader dr1 = cmd1.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        while(dr1.Read())
        {
            if(dr1["subID"].ToString() == industryID)
            {
                industryName = dr1["subName"].ToString();
            }
            bool match = false;
            for(int a=0; a<dontSend.Length; a++)
            {
                if(dontSend[a] == dr1["subID"].ToString())
                {
                    match = true;
                    a = dontSend.Length;
                }
            }
            if(!match)
            {
                subid2send[index++] = dr1["subID"].ToString();
            }
        }
        dr1.Close();
    
        //for each subid2send, retrieve related nasyspro members with same primary industry code
        for(int a=0; a<index; a++)
        {
            string connectionString3 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
            string conn_stmt3 = "select * from nasysclient where subid1='" + subid2send[a] + "'";
            SqlConnection conn3 = new SqlConnection(connectionString);
            SqlCommand cmd3 = new SqlCommand(conn_stmt3, conn3);
            cmd3.Connection.Open();
            SqlDataReader dr3 = cmd3.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
            while(dr3.Read())
            {
                string receiverEmail = dr3["ncEmail"].ToString();
                string[] temporary = dr3["ncExclude"].ToString().Split(new char[] {':'});
                string[] want2receive = temporary[1].Split(new char[] {','});
    
                bool matches = false;
                for(int b=0; b<want2receive.Length; b++)
                {
                    want2receive[b] = want2receive[b].Replace("'","");
                    if(want2receive[b] == industryID)
                    {
                        b = want2receive.Length;
                        matches = true;
                    }
                }
                if(matches)
                {
                    //Send newsletter
    
                    //Read newsletter content
                    string connectionString7 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                    string conn_stmt7 = "Select * from nlcontent where nlid='" + lblNLID.Text + "'";
                    SqlConnection conn7 = new SqlConnection(connectionString7);
                    SqlCommand cmd7 = new SqlCommand(conn_stmt7, conn7);
                    cmd7.Connection.Open();
                    SqlDataReader dr7 = cmd7.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
    
                    //Prepare email body
                    string mailbody;
    
                    mailbody = "<%@ Page Language='C#' ContentType='text/html' ResponseEncoding='iso-8859-1' %><html><head></head>";
                    mailbody += "<body leftmargin='0' background='http://demo.nasyspro.com/newsletter_template/template1/images/box/color1.gif' topmargin='0' marginwidth='0' marginheight='0'>";
                    mailbody += "<br /><table bordercolor='#ffffff' cellspacing='0' cellpadding='0' width='652' align='center' border='1'>";
                    mailbody += "<tbody><tr><td bgcolor='#cccccc'>";
                    mailbody += "<table cellspacing='0' cellpadding='0' width='652' align='center' border='0'>";
                    mailbody += "<tbody><tr>";
                    mailbody += "<td width='714' background='http://demo.nasyspro.com/newsletter_template/template1/images/gray/color1.gif'>";
                    mailbody += "<div align='right'><img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top1/color1.gif' width='158' />";
                    mailbody += "<img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top2/color1.gif' width='341' />";
                    mailbody += "<img height='55' src='http://demo.nasyspro.com/newsletter_template/template1/images/top3/color1.gif' width='130' />";
                    mailbody += "</div></td></tr></tbody></table>";
                    mailbody += "<table cellspacing='0' cellpadding='0' width='629' align='center' border='0'>";
                    mailbody += "<tbody><tr><td>";
                    mailbody += "<img height='18' src='http://demo.nasyspro.com/newsletter_template/template1/images/bar1/color1.gif' width='292' />";
                    mailbody += "<img height='18' src='http://demo.nasyspro.com/newsletter_template/template1/images/bar2/color1.gif' width='360' /></td>";
                    mailbody += "</tr></tbody></table>";
    
                    mailbody += "<table cellspacing='0' cellpadding='6' width='629' align='center' bgcolor='#CCCCCC' border='0'>";
                    mailbody += "<tr><td>Newsletter from <a href='http://" + domain + "'>" + company + "</a>";
                    mailbody += " (A member of <b>" + industryName + "</b> Industry) : </td></tr><tr><td>";
    
                    mailbody += "<table cellspacing='0' rules='all' border='1' style='width:629px; border-collapse:collapse;'>";
    
                    while (dr7.Read())
                    {
                        mailbody += "<tr><td align='center' valign='middle' width='140' style='background-color:Black;'>";
                        mailbody += "<img src='http://demo.nasyspro.com/private/nlshowinternal.aspx?img=" + dr7["nid"].ToString() + "&nl=" + dr7["nlid"].ToString() + "' border='0' style='width:140px;'>";
                        mailbody += "</td><td style='background-color:silver;'>";
                        mailbody += "<h3>" + dr7["nlName"].ToString() + "</h3><br>" + dr7["nlDescription"].ToString() + "</td></tr>";
                    }
                    dr7.Close();
    
                    mailbody += "</table></td></tr></table>";
    
                    mailbody += "<div align='center'><font face='Arial, Helvetica, sans-serif' color='#000000' size='1'><strong>";
                    mailbody += "<br />NasysPro - Your online business community is maintained and owned by<br />";
                    mailbody += "Nasys Technology Sdn Bhd <a href='mailto:webmaster@nasyspro.com'>webmaster</a> Copyright";
                    mailbody += "&#169; 2004 </strong></font></div><br>";
    
                    mailbody += "</td></tr></tbody></table></body></html>";
    
                    MailMessage mailss = new MailMessage();
                    mailss.To = receiverEmail;
                    mailss.From = email;
                    mailss.Subject = "Nasyspro Newsletter";
                    mailss.BodyFormat = MailFormat.Html;
                    mailss.Body = mailbody;
    
                    //Make sure "'" can be inserted into SQL server
                    mailbody = mailbody.Replace("'","''");
    
                    string connectionString8 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                    string conn_stmt8 = "select count(*) as counter from view_letter where nlid='" + lblNLID.Text + "'";
                    SqlConnection conn8 = new SqlConnection(connectionString8);
                    SqlCommand cmd8 = new SqlCommand(conn_stmt8, conn8);
                    cmd8.Connection.Open();
                    SqlDataReader dr8 = cmd8.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
                    if(dr8.Read())
                    {
                        //Check if related newsletter have been saved to database,
                        //if not exist (counter = 0), save it
                        //else just don't save
                        if(Convert.ToInt32(dr8["counter"]) == 0)
                        {
                            string connectionString9 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                            string conn_stmt9 = "insert into view_letter(details,nlid) values ('" + mailbody + "','" + lblNLID.Text + "')";
                            SqlConnection conn9 = new SqlConnection(connectionString9);
                            SqlCommand cmd9 = new SqlCommand(conn_stmt9, conn9);
                            cmd9.Connection.Open();
                            cmd9.ExecuteNonQuery();
                            cmd9.Connection.Close();
                        }
                        else
                        {
                            string connectionString00 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                            string conn_stmt00 = "update view_letter set details='" + mailbody + "' where nlid='" + lblNLID.Text + "'";
                            SqlConnection conn00 = new SqlConnection(connectionString00);
                            SqlCommand cmd00 = new SqlCommand(conn_stmt00, conn00);
                            cmd00.Connection.Open();
                            cmd00.ExecuteNonQuery();
                            cmd00.Connection.Close();
                        }
                    }
                    dr8.Close();
    
                    //get id for further usage on newsletter
                    string vlid = "";
    
                    string connectionString99 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                    string conn_stmt99 = "select * from view_letter where nlid='" + lblNLID.Text + "'";
                    SqlConnection conn99 = new SqlConnection(connectionString99);
                    SqlCommand cmd99 = new SqlCommand(conn_stmt99, conn99);
                    cmd99.Connection.Open();
                    SqlDataReader dr99 = cmd99.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
                    if(dr99.Read())
                    {
                        vlid = dr99["id"].ToString();
                    }
                    dr99.Close();
    
                    string mailbody2 = "<br>If this newsletter cannot be displayed properly, you can use the following methods to view the newsletter:";
                          mailbody2 += "<ol><li>Click on the hyperlink below to directly view the newsletter:<br>";
                          mailbody2 += "<a href='http://demo.nasyspro.com/newsletter_template/template1/view_letter1.aspx?id=" + vlid + "'>";
                          mailbody2 += "http://demo.nasyspro.com/newsletter_template/template1/view_letter1.aspx?id=" + vlid + "</a>";
                          mailbody2 += "</li><p>or</p><li>Copy the below URL and paste it to the address bar on your browser:<br>";
                          mailbody2 += "http://demo.nasyspro.com/newsletter_template/template1/view_letter1.aspx?id=" + vlid;
                          mailbody2 += "</li><p>or</p><li>Go to ";
                          mailbody2 += "<a href='http://demo.nasyspro.com/newsletter_template/template1/view_newsletter.aspx'>";
                          mailbody2 += "http://demo.nasyspro.com/newsletter_template/template1/view_newsletter.aspx</a>, ";
                          mailbody2 += "<br>type &quot;" + vlid + "&quot; (without the double quote) in the textbox on the site, then click on &quot;GO&quot; button.";
                          mailbody2 += "</li></ol><p>";
                          mailbody2 += "<i>Note: You receive this email because you have previously subscribed to our newsletter.";
                          mailbody2 += "If you decided not to receive further newsletter from our industry, you can ";
                          mailbody2 += "<a href='http://demo.nasyspro.com/newsletterset/sub_unsubscribe.aspx?";
                          mailbody2 += "subid=" + industryID + "&ncid=" + dr3["ncID"].ToString() + "'>";
                          mailbody2 += "unsubscribe</a>.</i></p>";
    
                    mailss.Body += mailbody2;
                    SmtpMail.Send(mailss);
                }
                else
                {
                    //Send notice to subindustries
                    string noticeBody = "";
                    noticeBody += "<html><head></head><body><a href='http://www.nasyspro.com'>";
                    noticeBody += "<img src='http://www.nasyspro.com/nasyspro_title_blue_long.jpg'";
                    noticeBody += " width='600' height='59' border='0'></a><br/><br/>";
                    noticeBody += "Dear " + dr3["ncEmail"].ToString() + ",<br><br><br><a href='http://" + domain + "'>";
                    noticeBody += company + "</a> (a member of <b>" + industryName + "</b> Industry) would like to send you a newsletter.";
                    noticeBody += "<br><br>Would you accept to receive this newsletter and other newsletters from this industry? ";
                    noticeBody += "If you want, please click on <a href='http://demo.nasyspro.com/newsletterset/sub_subscribe.aspx?";
                    noticeBody += "ncid=" + dr3["ncID"].ToString() + "&subid=" + industryID + "&nlid=" + lblNLID.Text + "&nid=" + User.Identity.Name + "'>";
                    noticeBody += "subscribe</a>.<br><br>";
                    noticeBody += "If you do not want to receive newsletters from our industry, please click on ";
                    noticeBody += "<a href='http://demo.nasyspro.com/newsletterset/sub_unsubscribe.aspx?";
                    noticeBody += "ncid=" + dr3["ncID"].ToString() + "&subid=" + industryID + "'>";
                    noticeBody += "ignore</a>.<br><br>";
                    noticeBody += "Yours sincerely,<br>The management<br><br><br>";
                    noticeBody += "<i>Note: You can unsubscribe the newsletter at a later time as well.</i>";
    
                    MailMessage notice = new MailMessage();
                    notice.To = dr3["ncEmail"].ToString();
                    notice.From = email;
                    notice.Subject = "Nasyspro Newsletter Invitation";
                    notice.BodyFormat = MailFormat.Html;
                    notice.Body = noticeBody;
    
                    SmtpMail.Send(notice);
    
                    noticeBody = noticeBody.Replace("'","''");
    
                    string connectionString5 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                    string conn_stmt5 = "select count(*) as counter from view_letter where nlid='" + lblNLID.Text + "'";
                    SqlConnection conn5 = new SqlConnection(connectionString5);
                    SqlCommand cmd5 = new SqlCommand(conn_stmt5, conn5);
                    cmd5.Connection.Open();
                    SqlDataReader dr5 = cmd5.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
                    if(dr5.Read())
                    {
                        if(Convert.ToInt32(dr5["counter"]) == 0)
                        {
                            string connectionString6 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                            string conn_stmt6 = "insert into view_letter(details,nlid) values('" + noticeBody + "','" + lblNLID.Text + "')";
                            SqlConnection conn6 = new SqlConnection(connectionString6);
                            SqlCommand cmd6 = new SqlCommand(conn_stmt6, conn6);
                            cmd6.Connection.Open();
                            cmd6.ExecuteNonQuery();
                            cmd6.Connection.Close();
                        }
                        else
                        {
                            string connectionString00 = ConfigurationSettings.AppSettings["SQLConnectionString"].ToString();
                            string conn_stmt00 = "update view_letter set details='" + noticeBody + "' where nlid='" + lblNLID.Text + "'";
                            SqlConnection conn00 = new SqlConnection(connectionString00);
                            SqlCommand cmd00 = new SqlCommand(conn_stmt00, conn00);
                            cmd00.Connection.Open();
                            cmd00.ExecuteNonQuery();
                            cmd00.Connection.Close();
                        }
                    }
                    dr5.Close();
                }
            }
        }
    }
    
    void Later(object o, CommandEventArgs e)
    {
        Response.Redirect("newletter_04.aspx");
    }
    
    void btnSend_Click(object sender, EventArgs e) {
    
    }

</script>
<html>
<head>
</head>
<body>
    <asp:Label id="lblNLID" visible="false" runat="server"></asp:Label><asp:Label id="Label1" visible="false" runat="server"></asp:Label> 
    <form id="form1" runat="server">
        <!-- #include file="top_border.aspx" -->
        <table cellspacing="0" cellpadding="6" width="800" align="center" bgcolor="#cccccc" border="0">
            <tbody>
                <tr>
                    <td colspan="4">
                        <font face="Arial, Helvetica, sans-serif" size="2"><strong>Newsletter Creation : Step&nbsp;4
                        -&nbsp;Send&nbsp;</strong></font> 
                        <br />
                        <br />
                        <font face="Arial, Helvetica, sans-serif" size="2">You can send to people already
                        on your maillist, or add in further more email addresses.<br />
                        Once you have finished selecting the email you wish to send to, click on 'Send' to
                        send out the completed newsletter. 
                        <p>
                            If you want to modify subindustries settings, please click <a onclick="window.open('nltest.aspx','')" href="javascript:void(0)">here</a>. 
                        </p>
                        </font></td>
                </tr>
                <tr>
                    <td>
                        <table width="700" align="center">
                            <tbody>
                                <tr>
                                    <td width="100">
                                        Send to email: 
                                    </td>
                                    <td>
                                        <strong>Your existing maillist:</strong><font color="#ff0000">*</font> 
                                        <br />
                                        <br />
                                        <asp:CheckBoxList id="cblMaillist" runat="server"></asp:CheckBoxList>
                                        <p>
                                            <font face="Arial" size="1"><i>You can also type in additional email addresses here,
                                            please separate each email address by a comma(,): </i></font>
                                            <asp:Textbox id="txtMail" runat="server" Width="300px"></asp:Textbox>
                                            <font color="#ff0000">**<br />
                                            </font>
                                            <asp:CheckBox id="chkIndustry" runat="server" Text="Send to other members from other subindustries"></asp:CheckBox>
                                        </p>
                                        <font face="Arial" color="#ff0000" size="1">*You can make modifications(adding, deleting)
                                        onto your maillist by clicking <a onclick="window.open('ml.aspx','')" href="javascript:void(0)">here</a> 
                                        <br />
                                        <br />
                                        **Once you send out newsletter to the above addresses, they will be automatically
                                        save to your maillist.</font> 
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div align="right">
                            <asp:button id="btnBack" runat="server" Text="Back" onCommand="Back_Click"></asp:button>
                            <asp:button id="btnRefresh" runat="server" Text="Refresh" onCommand="Refresh_Click"></asp:button>
                            <asp:button id="btnPreview" runat="server" Text="Preview" onCommand="Preview_Click"></asp:button>
                            &nbsp; 
                            <asp:button id="btnSend" onclick="btnSend_Click" runat="server" Text="Send" onCommand="Send_Click"></asp:button>
                            <asp:button id="btnSendLater" runat="server" Text="Send Later" onCommand="Later"></asp:button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
