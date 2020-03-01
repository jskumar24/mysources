<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="csAzureGonvernance.aspx.cs" Inherits="AzureGovernanceFoundation.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%--<h2><%: Title %>.</h2>--%>
    <div class="jumbotron">
        <p>
            <asp:Label ID="Label1" runat="server" Text="Azure Subscription:" Font-Size="Medium"></asp:Label>

            <asp:Label ID="lblSubscriptionName" runat="server" Font-Bold="False" Font-Size="Medium"></asp:Label>
        </p>
        <p>
            <asp:Label ID="Label2" runat="server" Font-Size="Medium" Text="Azure Policy:"></asp:Label>
&nbsp;</p>

        <table border="0" cellpadding="0" cellspacing="0" class="content_table_bg" width="100%">

            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;</td>
                <td align="left" style="width: 152px">&nbsp;</td>
                <td align="left" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="left" style="width: 501px" class="modal-sm">&nbsp;</td>
                <td align="left" style="width: 388px">&nbsp;</td>
            </tr>

            <tr>
                <td align="right" class="modal-sm" style="width: 637px">
                    <asp:Label ID="LblStatus" runat="server" CssClass="content_label" Text="In-Built Policy:"></asp:Label>
                </td>
                <td align="left" style="width: 152px">
                    <asp:DropDownList ID="ddlPolicies" runat="server" CssClass="form_dlist_box" Width="478px" Height="20px" Style="margin-left: 26">
                    </asp:DropDownList>
                </td>
                <td align="left" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="left" style="width: 501px" class="modal-sm">
                    <asp:RadioButton ID="rboSubscription" runat="server" AutoPostBack="True" OnCheckedChanged="rboSubscription_CheckedChanged" Text="Subscription" />
                </td>
                <td align="left" style="width: 388px">&nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">
                    <asp:Label ID="LblAgencyType" runat="server" CssClass="content_label" Text="Policy Name:"></asp:Label>
                </td>
                <td align="left" style="width: 152px">
                    <asp:TextBox ID="txtPolicyName" runat="server" Width="355px" Height="20px"></asp:TextBox>
                </td>
                <td align="left" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="left" style="width: 501px" class="modal-sm">
                    <asp:RadioButton ID="rboResoureGroup" runat="server" AutoPostBack="True" OnCheckedChanged="rboResoureGroup_CheckedChanged" Text="Resource Group" Font-Bold="False" />
                </td>
                <td align="left" style="width: 388px">&nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Label ID="LblLabelType" runat="server" CssClass="content_label" Text="Policy Display Name:"></asp:Label>
                </td>
                <td align="Left" style="width: 152px">
                    <asp:TextBox ID="txtPolicyDisplayName" runat="server" Width="355px" Height="20px"></asp:TextBox>
                </td>
                <td align="right" style="width: 327px" class="modal-sm">
                    <asp:Label ID="lblRGroup" runat="server" CssClass="content_label" Text="Resource Groups:"></asp:Label>
                </td>
                <td style="width: 501px; text-align: left;" class="modal-sm">
                    <asp:DropDownList ID="ddlRG" runat="server" Height="20px" Width="334px">
                    </asp:DropDownList>
                </td>
                <td style="width: 388px" class="text-left" rowspan="3">&nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">
                    <asp:Label ID="lblClassId" runat="server" CssClass="content_label" Text="Policy Descrption:"></asp:Label>
                </td>
                <td align="left" style="width: 152px">
                    <asp:TextBox ID="txtPolicyDescription" runat="server" Width="355px" Height="20px"></asp:TextBox>
                </td>
                <td align="right" style="width: 327px" class="modal-sm">
                    <asp:Label ID="LblAgencyType0" runat="server" CssClass="content_label" Text="Parameter Value:"></asp:Label>
                </td>
                <td align="right" style="width: 501px; text-align: left;" class="modal-sm">
                    <asp:TextBox ID="txtParameterValue" runat="server" Width="355px" Height="20px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;</td>
                <td align="left" style="width: 152px">&nbsp;</td>
                <td align="right" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 501px" class="modal-sm">&nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;</td>
                <td align="left" style="width: 152px">
                    <asp:Button ID="btnAddPolicy" runat="server" OnClick="btnAddPolicy_Click" Text="Add" Width="110px" />
                </td>
                <td align="right" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 501px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 388px">&nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;</td>
                <td align="left" style="width: 152px">&nbsp;</td>
                <td align="right" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 501px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 388px">&nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;</td>
                <td align="left" colspan="4">
                    <asp:GridView ID="Gridview1" runat="server" ShowFooter="true"
                        AutoGenerateColumns="False"
                        OnRowCreated="Gridview1_RowCreated">
                        <Columns>
                            <asp:BoundField DataField="Sno" HeaderText="Sno" ReadOnly="true" />
                            <asp:TemplateField HeaderText="Selected Policy">
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox1" runat="server" ReadOnly="true"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Policy Name">
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" ReadOnly="true"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Policy Display Name">
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" ReadOnly="true"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Policy Description">
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" ReadOnly="true"></asp:TextBox>
                                </ItemTemplate>
                                <FooterStyle HorizontalAlign="Right" />
                                <FooterTemplate>
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server"
                                        OnClick="LinkButton1_Click">Remove</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;</td>
                <td align="left" style="width: 152px">&nbsp;</td>
                <td align="right" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 501px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 388px">&nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="modal-sm" style="width: 637px">&nbsp;</td>
                <td align="left" style="width: 152px">
                    <asp:Button ID="btnCreatePolicies" runat="server" OnClick="btnCreatePolicies_Click" Text="Create Policy" />
                </td>
                <td align="right" style="width: 327px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 501px" class="modal-sm">&nbsp;</td>
                <td align="right" style="width: 388px">&nbsp;</td>
            </tr>
        </table>
    </div>
</asp:Content>
