<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="csAzureActiveDirectory.aspx.cs" Inherits="AzureGovernanceFoundation.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="jumbotron">
        <%--<h2><%: Title %>.</h2>
    <h3>Your application description page.</h3>
    <p>Use this area to provide additional information.</p>--%>
        <p>
            <asp:Label ID="Label2" runat="server" Text="Azure Subscription:" Font-Size="Medium"></asp:Label>

            <asp:Label ID="lblSubscriptionName" runat="server" Font-Bold="False" Font-Size="Medium"></asp:Label>
        </p>
        <p>
            <asp:Label ID="Label3" runat="server" Font-Size="Medium" Text="Bulk User Creation:"></asp:Label>
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
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>
</asp:Content>
