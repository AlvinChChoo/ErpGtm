// According to http://msdn2.microsoft.com/en-us/library/system.web.httppostedfile.aspx
// "Files are uploaded in MIME multipart/form-data format. 
// By default, all requests, including form fields and uploaded files, 
// larger than 256 KB are buffered to disk, rather than held in server memory."
// So we can use an HttpHandler to handle uploaded files and not have to worry
// about the server recycling the request do to low memory. 
// don't forget to increase the MaxRequestLength in the web.config.
// If you server is still giving errors, then something else is wrong.
// I've uploaded a 1.3 gig file without any problems. One thing to note, 
// when the SaveAs function is called, it takes time for the server to 
// save the file. The larger the file, the longer it takes.
// So if a progress bar is used in the upload, it may read 100%, but the upload won't
// be complete until the file is saved.  So it may look like it is stalled, but it
// is not.

using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

/// <summary>
/// Upload handler for uploading files.
/// </summary>
public class Upload : IHttpHandler 
{
    public Upload()
    {
    }

    #region IHttpHandler Members

    public bool IsReusable
    {
        get { return true; }
    }

    public void ProcessRequest(HttpContext context)
    {
        // Example of using a passed in value in the query string to set a categoryId
        // Now you can do anything you need to witht the file.
        //int categoryId = 0;
       //if (context.Request.QueryString["CategoryID"] != null)
       //{
         //  try
         //  {
         //      categoryId = Convert.ToInt32(context.Request.QueryString["CategoryID"]);
         //  }
         //  catch (Exception err)
         // {
         //      categoryId = 0;
         //  }
       // }
       // if (categoryId > 0)
       // {
       // }
        
        if (context.Request.Files.Count > 0)
        {
            // get the applications path
            string tempFile = context.Request.PhysicalApplicationPath;
            // loop through all the uploaded files
            for(int j = 0; j < context.Request.Files.Count; j++)
            {
                // get the current file
                HttpPostedFile uploadFile = context.Request.Files[j];
                
                // if there was a file uploded
                if (uploadFile.ContentLength > 0)
                {
                    // save the file to the upload directory
                    
                    //use this if testing from a classic style upload, ie. 

                    // <form action="Upload.axd" method="post" enctype="multipart/form-data">
                    //    <input type="file" name="fileUpload" />
                    //    <input type="submit" value="Upload" />
                    //</form>

                    // this is because flash sends just the filename, where the above 
                    //will send the file path, ie. c:\My Pictures\test1.jpg
                    //you can use Test.thm to test this page.
                    //string filename = uploadFile.FileName.Substring(uploadFile.FileName.LastIndexOf("\\"));
                    //uploadFile.SaveAs(string.Format("{0}{1}{2}", tempFile, "OrdersAttachment\\", filename));
                    string sFileName = context.Request.QueryString["spath"];
                    string sPath = context.Request.QueryString["sdir"];
                    // use this if using flash to upload

		
		    uploadFile.SaveAs(string.Format("{0}{1}{2}", tempFile, "OrdersAttachment\\", sFileName+uploadFile.FileName));
		

                    //byte[] fileData = new byte[uploadFile.ContentLength];
                    //uploadFile.InputStream.Write(fileData, 0, fileData.Length);
                    // HttpPostedFile has an InputStream also.  You can pass this to 
                    // a function, or business logic. You can save it a database:

                    //byte[] fileData = new byte[uploadFile.ContentLength];
                    //uploadFile.InputStream.Read (fileData, 0, fileData.Length);
                    // save byte array into database.

                    // something I do is extract files from a zip file by passing
                    // the inputStream to a function that uses SharpZipLib found here:
                    // http://www.icsharpcode.net/OpenSource/SharpZipLib/
                    // and then save the files to disk.   
                    //Console.WriteLine("testing");

                }                
            }
        }
        // Used as a fix for a bug in mac flash player that makes the 
        // onComplete event not fire
        HttpContext.Current.Response.Write("");
    }

    #endregion
}
