<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="csAzureSiteRecovery.aspx.cs" Inherits="AzureGovernanceFoundation.csAzureSiteRecovery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="jumbotron">
        <p>
            <asp:Label ID="Label4" runat="server" Text="Azure Subscription:" Font-Size="Medium"></asp:Label>

            <asp:Label ID="lblSubscriptionName" runat="server" Font-Bold="False" Font-Size="Medium"></asp:Label>
        </p>
        <p>
            <asp:Label ID="Label5" runat="server" Font-Size="Medium" Text="Azure Site Recovery: Bulk"></asp:Label>
            &nbsp;
        </p>
        <table class="nav-justified">
            <tr>
                <td style="width: 40px">&nbsp;</td>
                <td style="width: 82px">&nbsp;</td>
                <td class="modal-sm" style="width: 214px">&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 40px">&nbsp;</td>
                <td class="text-right" style="width: 82px">
                    <asp:Label ID="Label1" runat="server" Text="Upload File:"></asp:Label>
                </td>
                <td class="modal-sm" style="width: 214px">
                    <asp:FileUpload ID="FileUpload1" runat="server" Width="478px" />
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 40px">&nbsp;</td>
                <td style="width: 82px">&nbsp;</td>
                <td class="modal-sm" style="width: 214px">&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 40px">&nbsp;</td>
                <td style="width: 82px">&nbsp;</td>
                <td class="modal-sm" style="width: 214px">
                    <asp:Button ID="btnCreatePolicies" runat="server" Text="Create Users" Style="margin-bottom: 13" />
                </td>
                <td>
                    <asp:Button ID="Button1" runat="server" Text="Cancel" />
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>

</asp:Content>
