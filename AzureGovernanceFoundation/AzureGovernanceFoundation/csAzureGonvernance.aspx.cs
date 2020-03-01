using System;
using System.Text;
using System.Web.UI;
using System.Windows.Input;
using Microsoft.Azure.Management;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.IO;
using System.Collections;
using System.Linq;
using System.Data;
using System.Web.UI.WebControls;
using System.Threading;
using System.Collections.Generic;
using System.Web;
using System.Web.Configuration;
using Microsoft.Azure.Management.Compute.Fluent;
using Microsoft.Azure.Management.Compute.Fluent.Models;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager;
using Microsoft.Azure.Management.ResourceManager.Fluent;

using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;

using Microsoft.Azure.Subscriptions;
using Microsoft.Azure.Subscriptions.Models;

using Microsoft.Azure.Common;

using Microsoft.Azure.Management.Resources;
using Microsoft.Azure.Management.Resources.Models;

using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.Models;

using Microsoft.Azure.Management.Storage.Fluent;
using Microsoft.Azure.Management.Storage.Fluent.PolicyRule;
using Microsoft.Azure.Management.Storage.Fluent.ManagementPolicy;
using Microsoft.Azure.Management.Storage.Fluent.ImmutabilityPolicy;
using Newtonsoft.Json.Linq;

namespace AzureGovernanceFoundation
{
    public partial class Contact : Page
    {
        PowerShell powerShellScript = PowerShell.Create();
        DataTable dt = new DataTable();
        DataRow dr = null;
        string fileAzAuthPath = WebConfigurationManager.AppSettings["azurefilePath"];
        IAzure azureObj;
        string ExistingRGName = "AZ-HYD-Cloud-POC";
        IAzure AzureLoad(string filePath)
        {
            var credentials = SdkContext.AzureCredentialsFactory.FromFile(filePath);
            var azureObject = Azure
                .Configure()
                .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
                .Authenticate(credentials)
                .WithDefaultSubscription();
            return azureObject;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            azureObj = AzureLoad(fileAzAuthPath);

            var subscriptionName = azureObj.GetCurrentSubscription();
            lblSubscriptionName.Text = subscriptionName.DisplayName;

            ddlRG.Enabled = false;
            lblRGroup.Enabled = false;
            if (!IsPostBack)
            {
                //LoadLoginDetails();
                LoadGetResourceGroups();
                LoadPolicyDisplayName();
                SetInitialRow();
            }
        }
        private ArrayList GetDummyData()
        {

            ArrayList arr = new ArrayList();

            arr.Add(new ListItem("Item1", "1"));
            arr.Add(new ListItem("Item2", "2"));
            arr.Add(new ListItem("Item3", "3"));
            arr.Add(new ListItem("Item4", "4"));
            arr.Add(new ListItem("Item5", "5"));

            return arr;
        }
        private void FillDropDownList(DropDownList ddl)
        {
            ArrayList arr = GetDummyData();

            foreach (ListItem item in arr)
            {
                ddl.Items.Add(item);
            }
        }
        private void SetInitialRow()
        {

            DataTable dt = new DataTable();
            DataRow dr = null;

            dt.Columns.Add(new DataColumn("Sno", typeof(string)));
            dt.Columns.Add(new DataColumn("Selected Policy", typeof(string)));//for TextBox value   
            dt.Columns.Add(new DataColumn("Policy Name", typeof(string)));//for TextBox value   
            dt.Columns.Add(new DataColumn("Policy Display Name", typeof(string)));//for DropDownList selected item   
            dt.Columns.Add(new DataColumn("Policy Description", typeof(string)));//for DropDownList selected item   

            dr = dt.NewRow();
            dr["Sno"] = 1;
            dr["Selected Policy"] = string.Empty;
            dr["Policy Name"] = string.Empty;
            dr["Policy Display Name"] = string.Empty;
            dr["Policy Description"] = string.Empty;
            dt.Rows.Add(dr);

            //Store the DataTable in ViewState for future reference   
            ViewState["CurrentTable"] = dt;

            //Bind the Gridview   
            Gridview1.DataSource = dt;
            Gridview1.DataBind();
        }
        private void AddNewRowToGrid()
        {
            int rowIndex = 0;
            if (ViewState["CurrentTable"] != null)
            {
                DataTable dtCurrentTable = (DataTable)ViewState["CurrentTable"];
                DataRow drCurrentRow = null;

                if (Gridview1.Rows.Count > 0)
                {
                    for (int i = 1; i <= dtCurrentTable.Rows.Count; i++)
                    {
                        //extract the TextBox values   

                        TextBox box1 = (TextBox)Gridview1.Rows[rowIndex].Cells[1].FindControl("TextBox1");
                        TextBox box2 = (TextBox)Gridview1.Rows[rowIndex].Cells[2].FindControl("TextBox2");
                        TextBox box3 = (TextBox)Gridview1.Rows[rowIndex].Cells[3].FindControl("TextBox3");
                        TextBox box4 = (TextBox)Gridview1.Rows[rowIndex].Cells[4].FindControl("TextBox4");

                        drCurrentRow = dtCurrentTable.NewRow();
                        drCurrentRow["Sno"] = dtCurrentTable.Rows.Count + 1;

                        dtCurrentTable.Rows[i - 1]["Selected Policy"] = box1.Text;
                        dtCurrentTable.Rows[i - 1]["Policy Name"] = box2.Text;
                        dtCurrentTable.Rows[i - 1]["Policy Display Name"] = box3.Text;
                        dtCurrentTable.Rows[i - 1]["Policy Description"] = box4.Text;
                        rowIndex++;
                    }

                    //dtCurrentTable.Rows.Add(drCurrentRow);

                    drCurrentRow = dtCurrentTable.NewRow();
                    drCurrentRow["Sno"] = dtCurrentTable.Rows.Count + 1;

                    dtCurrentTable.Rows[dtCurrentTable.Rows.Count - 1]["Selected Policy"] = ddlPolicies.Text;
                    dtCurrentTable.Rows[dtCurrentTable.Rows.Count - 1]["Policy Name"] = txtPolicyName.Text;
                    dtCurrentTable.Rows[dtCurrentTable.Rows.Count - 1]["Policy Display Name"] = txtPolicyDisplayName.Text;
                    dtCurrentTable.Rows[dtCurrentTable.Rows.Count - 1]["Policy Description"] = txtPolicyDescription.Text;

                    //add new row to DataTable   
                    dtCurrentTable.Rows.Add(drCurrentRow);
                    //Store the current data to ViewState for future reference   
                    ViewState["CurrentTable"] = dtCurrentTable;


                    //Rebind the Grid with the current data to reflect changes
                    Gridview1.DataSource = dtCurrentTable;
                    Gridview1.DataBind();

                }
            }
            else
            {
                Response.Write("ViewState is null");

            }
            //Set Previous Data on Postbacks   
            SetPreviousData();
        }
        private void SetPreviousData()
        {

            int rowIndex = 0;
            if (ViewState["CurrentTable"] != null)
            {

                DataTable dt = (DataTable)ViewState["CurrentTable"];
                if (dt.Rows.Count > 0)
                {

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {

                        TextBox box1 = (TextBox)Gridview1.Rows[i].Cells[1].FindControl("TextBox1");
                        TextBox box2 = (TextBox)Gridview1.Rows[i].Cells[2].FindControl("TextBox2");
                        TextBox box3 = (TextBox)Gridview1.Rows[i].Cells[3].FindControl("TextBox3");
                        TextBox box4 = (TextBox)Gridview1.Rows[i].Cells[4].FindControl("TextBox4");

                        if (i < dt.Rows.Count - 1)
                        {

                            //Assign the value from DataTable to the TextBox   
                            box1.Text = dt.Rows[i]["Selected Policy"].ToString();
                            box2.Text = dt.Rows[i]["Policy Name"].ToString();
                            box3.Text = dt.Rows[i]["Policy Display Name"].ToString();
                            box4.Text = dt.Rows[i]["Policy Description"].ToString();
                        }

                        rowIndex++;
                    }
                }
            }
        }
        void LoadLoginDetails()
        {
            ArrayList rgList = new ArrayList();
            rgList = RunScript(LoadScript(@"C:\Users\winadmin\source\repos\Azure_Governance\Azure_Governance\Allowed_Policies\Login-Azure.ps1"));
            String ObjStr = "";
            foreach (var item in rgList)
            {
                ObjStr += item.ToString().Replace("Name                           ----                           ", "");
            }
            lblSubscriptionName.Text = ObjStr;
        }
        void LoadGetResourceGroups()
        {
            ArrayList rgroupList = new ArrayList();
            var resourceGroups = azureObj.ResourceGroups.List();
            //resourceGroups.ToList().Sort();
            ddlRG.Items.Clear();
            foreach (var item in resourceGroups)
            {
                ddlRG.Items.Add(item.Name);
            }
        }
        //IResource azurePolicyDefinitions(string filePath)
        //{

        //    var credentials = SdkContext.AzureCredentialsFactory.FromFile(filePath);
        //    //var azureDefinitions = azureObj

        //    return azureDefinitionStages;
        //}
        void LoadPolicyDisplayName()
        {
            ArrayList rgList = new ArrayList();
            rgList = RunScript(LoadScript(@"C:\Users\winadmin\source\repos\Azure_Governance\Azure_Governance\Allowed_Policies\GetPolicyDisplayName.ps1"));
            rgList.Sort();
            ddlPolicies.Items.Clear();
            foreach (var item in rgList)
            {
                ddlPolicies.Items.Add(item.ToString());
            }
        }
        protected void Gridview1_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataTable dt = (DataTable)ViewState["CurrentTable"];
                LinkButton lb = (LinkButton)e.Row.FindControl("LinkButton1");
                if (lb != null)
                {
                    if (dt.Rows.Count > 1)
                    {
                        if (e.Row.RowIndex == dt.Rows.Count - 1)
                        {
                            lb.Visible = false;
                        }
                    }
                    else
                    {
                        lb.Visible = false;
                    }
                }
            }
        }
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            GridViewRow gvRow = (GridViewRow)lb.NamingContainer;
            int rowID = gvRow.RowIndex;
            if (ViewState["CurrentTable"] != null)
            {

                DataTable dt = (DataTable)ViewState["CurrentTable"];
                if (dt.Rows.Count > 1)
                {
                    if (gvRow.RowIndex < dt.Rows.Count - 1)
                    {
                        //Remove the Selected Row data and reset row number  
                        dt.Rows.Remove(dt.Rows[rowID]);
                        ResetRowID(dt);
                    }
                }

                //Store the current data in ViewState for future reference  
                ViewState["CurrentTable"] = dt;

                //Re bind the GridView for the updated data  
                Gridview1.DataSource = dt;
                Gridview1.DataBind();
            }

            //Set Previous Data on Postbacks  
            SetPreviousData();
        }
        private void ResetRowID(DataTable dt)
        {
            int rowNumber = 1;
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    row[0] = rowNumber;
                    rowNumber++;
                }
            }
        }
        // helper method that takes your script path, loads up the script 
        // into a variable, and passes the variable to the RunScript method 
        // that will then execute the contents 
        private string LoadScript(string filename)
        {
            try
            {
                // Create an instance of StreamReader to read from our file. 
                // The using statement also closes the StreamReader. 
                using (StreamReader sr = new StreamReader(filename))
                {

                    // use a string builder to get all our lines from the file 
                    StringBuilder fileContents = new StringBuilder();

                    // string to hold the current line 
                    string curLine;

                    // loop through our file and read each line into our 
                    // stringbuilder as we go along 
                    while ((curLine = sr.ReadLine()) != null)
                    {
                        // read each line and MAKE SURE YOU ADD BACK THE 
                        // LINEFEED THAT IT THE ReadLine() METHOD STRIPS OFF 
                        fileContents.Append(curLine + "\n");
                    }

                    // call RunScript and pass in our file contents 
                    // converted to a string 
                    return fileContents.ToString();
                }
            }
            catch (Exception e)
            {
                // Let the user know what went wrong. 
                string errorText = "The file could not be read:";
                errorText += e.Message + "\n";
                return errorText;
            }

        }
        private ArrayList RunScript(string scriptText)
        {
            // create Powershell runspace 
            Runspace runspace = RunspaceFactory.CreateRunspace();

            // open it 
            runspace.Open();

            // create a pipeline and feed it the script text 
            Pipeline pipeline = runspace.CreatePipeline();
            pipeline.Commands.AddScript(scriptText);

            // add an extra command to transform the script output objects into nicely formatted strings 
            // remove this line to get the actual objects that the script returns. For example, the script 
            // "Get-Process" returns a collection of System.Diagnostics.Process instances. 
            pipeline.Commands.Add("Out-String");

            // execute the script 
            Collection<PSObject> results = pipeline.Invoke();

            // close the runspace 
            runspace.Close();

            // convert the script result into a single string 
            StringBuilder strBuilder = new StringBuilder();
            foreach (PSObject obj in results)
            {
                strBuilder.AppendLine(obj.ToString());
            }

            string[] stringArray = strBuilder.ToString().Replace("\r", "").Replace("\n", "").Split(',').ToArray();

            ArrayList returnList = new ArrayList(stringArray);

            return returnList;
        }
        /// <summary>
        /// Event handler for when data is added to the output stream.
        /// </summary>
        /// <param name="sender">Contains the complete PSDataCollection of all output items.</param>
        /// <param name="e">Contains the index ID of the added collection item and the ID of the PowerShell instance this event belongs to.</param>
        void outputCollection_DataAdded(object sender, DataAddedEventArgs e)
        {
            // do something when an object is written to the output stream
            Console.WriteLine("Object added to output.");
        }
        /// <summary>
        /// Event handler for when Data is added to the Error stream.
        /// </summary>
        /// <param name="sender">Contains the complete PSDataCollection of all error output items.</param>
        /// <param name="e">Contains the index ID of the added collection item and the ID of the PowerShell instance this event belongs to.</param>
        void Error_DataAdded(object sender, DataAddedEventArgs e)
        {
            // do something when an error is written to the error stream
            Console.WriteLine("An error was written to the Error stream!");
        }
        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void rboSubscription_CheckedChanged(object sender, EventArgs e)
        {
            ddlRG.SelectedIndex = 0;
            //ddlRG.Text = "";
            ddlRG.Enabled = false;
            lblRGroup.Enabled = false;
            rboResoureGroup.Checked = false;
        }
        protected void rboResoureGroup_CheckedChanged(object sender, EventArgs e)
        {
            ddlRG.Enabled = true;
            lblRGroup.Enabled = true;
            rboSubscription.Checked = false;
        }
        protected void ddlPolicies_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void btnAddPolicy_Click(object sender, EventArgs e)
        {
            AddNewRowToGrid();
            txtPolicyDescription.Text = "";
            txtPolicyDisplayName.Text = "";
            txtPolicyName.Text = "";
        }
        protected void btnCreatePolicies_Click(object sender, EventArgs e)
        {
            int rowIndex = 0;
            for (int i = 0; i < Gridview1.Rows.Count; i++)
            {
                TextBox box1 = (TextBox)Gridview1.Rows[rowIndex].Cells[1].FindControl("TextBox1");
                TextBox box2 = (TextBox)Gridview1.Rows[rowIndex].Cells[2].FindControl("TextBox2");
                TextBox box3 = (TextBox)Gridview1.Rows[rowIndex].Cells[3].FindControl("TextBox3");
                TextBox box4 = (TextBox)Gridview1.Rows[rowIndex].Cells[4].FindControl("TextBox4");

                var _selectedPolicyName = box1.Text;
                var _policyName = box2.Text;
                var _policyDisplayName = box3.Text;
                var _policyDescription = box4.Text;

                //string _strObj = "$password = ConvertTo-SecureString 'Jradha3#' -AsPlainText -Force;";
                //_strObj += "$credential = New - Object System.Management.Automation.PSCredential('sathish@virtusacloudstaas.onmicrosoft.com', $password);";
                //_strObj += "Connect - AzureRmAccount - Credential $Credential - Subscription '419fc527-9b96-42c1-8151-477ef2bcd158' - Tenant '0b97c5d2-2b9a-4dd2-8074-7298f9d603b5';";
                //_strObj += "$definition = New-AzureRmPolicyDefinition -Name";

                List<string> _paraCollections = new List<string>();

                string _paraSubscriptionId = "419fc527-9b96-42c1-8151-477ef2bcd158";
                string _paraTenant = "0b97c5d2-2b9a-4dd2-8074-7298f9d603b5";
                string _paraUsername = "sathish@virtusacloudstaas.onmicrosoft.com";
                string _parapwd = "Jradha3#";

                string scopeValue = "";
                if (rboResoureGroup.Checked)
                {
                    scopeValue = ddlRG.SelectedValue;
                }

                if (rboSubscription.Checked)
                {
                    scopeValue = "/subscriptions/" + _paraSubscriptionId;
                }

                _paraCollections.Add(_paraSubscriptionId);
                _paraCollections.Add(_paraTenant);
                _paraCollections.Add(_paraUsername);
                _paraCollections.Add(_parapwd);

                int _indexPolicy = ddlPolicies.Items.IndexOf(ddlPolicies.Items.FindByText(_selectedPolicyName));

                using (PowerShell PowerShellInstance = PowerShell.Create())
                {
                    if (_indexPolicy == (int)Policies.Allowed_Locations)
                    {
                        // use "AddScript" to add the contents of a script file to the end of the execution pipeline.
                        // use "AddCommand" to add individual commands/cmdlets to the end of the execution pipeline.
                        //strObj += "$definition = New-AzureRmPolicyDefinition -Name 'virtusa-allowed-locations1234' -DisplayName 'Virtusa Allowed locations 1234' -description 'This policy enables you to restrict the locations your organization can specify when deploying resources. ' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.parameters.json' -Mode Indexed;";
                        //strObj += "$definition = New-AzureRmPolicyDefinition -Name 'virtusa-allowed-locations1234' -DisplayName 'Virtusa Allowed locations 1234' -description 'This policy enables you to restrict the locations your organization can specify when deploying resources. ' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.parameters.json' -Mode Indexed;";

                        _paraCollections.Add(_policyName);
                        _paraCollections.Add(_policyDisplayName);
                        _paraCollections.Add(_policyDescription);

                        string paraTemplateRules = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.rules.json";
                        string paraTemplateParameters = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.parameters.json";
                        string paraParameterValues = txtParameterValue.Text;


                        _paraCollections.Add(paraTemplateRules);
                        _paraCollections.Add(paraTemplateParameters);
                        _paraCollections.Add(scopeValue);
                        if (txtParameterValue.Text != "")
                        {
                            JObject json = JObject.Parse(paraParameterValues);
                            _paraCollections.Add(paraParameterValues);
                        }
                        string filescript = @"C:\Users\winadmin\source\repos\Azure_Governance\Azure_Governance\Allowed_Policies\allowed-locations\allowedLocation.ps1";

                        PowerShellInstance.AddScript(filescript);
                        PowerShellInstance.AddParameters(_paraCollections);

                        // begin invoke execution on the pipeline
                        IAsyncResult result = PowerShellInstance.BeginInvoke();

                        // do something else until execution has completed.
                        // this could be sleep/wait, or perhaps some other work
                        while (result.IsCompleted == false)
                        {
                            Thread.Sleep(1000);
                        }
                    }
                }
            }
            rowIndex++;
            MessageBox.Show(this, "Successfully Policies Created!...");
        }
    }

    public static class MessageBox
    {
        public static void Show(this Page Page, String Message)
        {
            Page.ClientScript.RegisterStartupScript(
               Page.GetType(),
               "MessageBox",
               "<script language='javascript'>alert('" + Message + "');</script>"
            );
        }
    }

    [Microsoft.Rest.Serialization.JsonTransformation]
    public class PolicyAssignment : Microsoft.Rest.Azure.IResource
    {

    }
    public enum Policies
    {
        Allowed_Locations = 1
    }
}