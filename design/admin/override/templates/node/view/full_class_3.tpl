{default with_children=true()
         is_editable=true()
	 is_standalone=true()}
{let page_limit=25
     list_count=and($with_children,fetch('content','list_count',hash(parent_node_id,$node.node_id)))}
{default content_object=$node.object
         content_version=$node.contentobject_version_object
         node_name=$node.name}

{section show=$is_standalone}
<form method="post" action={"content/action"|ezurl}>
{/section}

<table cellspacing="5" cellpadding="0" border="0">
<tr>
	<td>
 	<div class="maincontentheader">
        <h1>{$node_name}</h1>
        </div>
	<input type="hidden" name="TopLevelNode" value="{$content_object.main_node_id}" />
	</td>
</tr>
</table>

<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <td width="120" valign="top">

    {let name=Object  related_objects=$content_version.related_contentobject_array}

      {section name=ContentObject  loop=$Object:related_objects show=$Object:related_objects  sequence=array(bglight,bgdark)}

        <div class="block">
        {content_view_gui view=text_linked content_object=$Object:ContentObject:item}
        </div>
    
      {section-else}
      {/section}
    {/let}

    {section show=$is_standalone}
      {section name=ContentAction loop=$content_object.content_action_list show=$content_object.content_action_list}
      <div class="block">
      <input type="submit" name="{$ContentAction:item.action}" value="{$ContentAction:item.name}" />
      </div>
      {/section}
    {/section}
    </td>

</tr>
</table>

{section show=$is_editable}
   {switch match=$content_object.can_edit}
   {case match=1}
   <input type="hidden" name="ContentObjectID" value="{$content_object.id}" />
   <input class="button" type="submit" name="EditButton" value="{'Edit'|i18n('design/standard/node/view')}" />
   {/case}
   {case match=0}
   {/case}
   {/switch}
{/section}


{section show=$with_children}

{let children=fetch('content','list',hash(parent_node_id,$node.node_id,sort_by,$node.sort_array,limit,$page_limit,offset,$view_parameters.offset))}

{section show=$children}

<hr noshade="noshade" />

<table class="list" width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <th>
    {"Name:"|i18n("design/standard/node/view")}
    </th>
    <th>
    {"Class:"|i18n("design/standard/node/view")}
    </th>
    {section show=eq($node.sort_array[0][0],'priority')}
    <th>
    {"Priority:"|i18n("design/standard/node/view")}
    </th>
    {/section}
    <th>
    {"Edit:"|i18n("design/standard/node/view")}
    </th>
    <th>
    {"Copy:"|i18n("design/standard/node/view")}
    </th>
    <th colspan="2" align="right" width="1">
    {"Remove:"|i18n("design/standard/node/view")}
    </th>
</tr>
{section name=Child loop=$children  sequence=array(bglight,bgdark)}
<tr>
	<td class="{$Child:sequence}">
        <a href={concat('content/view/full/',$Child:item.node_id)|ezurl}>
<a href={concat('content/view/full/',$Child:item.node_id)|ezurl}>
{switch match=$Child:item.object.contentclass_id}
{case match=4}
 <img src={"user.gif"|ezimage} border="0" alt="{'User'|i18n('design/standard/node/view')}" />
{/case}
{case match=3}
 <img src={"usergroup.gif"|ezimage} border="0" alt="{'User group'|i18n('design/standard/node/view')}" />
{/case}
{case}
 <img src={"class_2.png"|ezimage} border="0" alt="{'Document'|i18n('design/standard/node/view')}" />
{/case}
{/switch}
&nbsp;
{$Child:item.name}</a>
</a>
	</td>
        <td class="{$Child:sequence}">{$Child:item.object.class_name}
	</td>
	{section show=eq($node.sort_array[0][0],'priority')}
	<td width="40" align="left" class="{$Child:sequence}">
	  <input type="text" name="Priority[]" size="2" value="{$Child:item.priority}">
          <input type="hidden" name="PriorityID[]" value="{$Child:item.node_id}">
	</td>
	{/section}

	{switch name=sw match=$Child:item.object.can_edit}
        {case match=1}
	<td width="1%" class="{$Child:sequence}">
        <a href={concat("content/edit/",$Child:item.contentobject_id)|ezurl}><img src={"edit.png"|ezimage} alt="Edit" border="0" /></a>
        </td>
	{/case}
        {case} 
	<td class="{$Child:sequence}" width="1%">
	</td>
        {/case}
        {/switch}
        <td class="{$Child:sequence}">
          <a href={concat("content/copy/",$Child:item.contentobject_id)|ezurl}><img src={"copy.png"|ezimage} alt="{'Copy'|i18n('design/standard/node/view')}" border="0"></a>
        </td>

	{switch name=sw match=$Child:item.object.can_remove}
        {case match=1}
	<td class="{$Child:sequence}" align="right" width="1">
             <input type="checkbox" name="DeleteIDArray[]" value="{$Child:item.node_id}" />
	</td>
	{/case}
        {case} 
	<td class="{$Child:sequence}" align="right" width="1%">
	</td>
	<td width="1%" class="{$Child:sequence}"></td>
        {/case}
        {/switch} 
</tr>
{/section}
<tr>
    <td>
    </td>
    <td>
    </td>
    {section show=eq($node.sort_array[0][0],'priority')}
    <td>
    {switch match=$content_object.can_edit}
        {case match=1}
        {section show=eq($node.sort_array[0][0],'priority')}
         <input class="button" type="submit"  name="UpdatePriorityButton" value="{'Update'|i18n('design/standard/node/view')}" />
        {/section}
        {/case}
        {case}
        {/case}
    {/switch}
    </td>
    {/section}
    <td>
    </td>
    <td>
    </td>
    <td align="right" width="1">
    {section show=fetch('content','list',hash(parent_node_id,$node.node_id,sort_by,$node.sort_array,limit,$page_limit,offset,$view_parameters.offset))}
    <input type="image" name="RemoveButton" value="{'Remove'|i18n('design/standard/node/view')}" src={"trash.png"|ezimage} />
    {/section}
    </td>
</tr>
</table>

{/section}
{/let}

{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri=concat('/content/view','/full/',$node.node_id)
         item_count=$list_count
         view_parameters=$view_parameters
         item_limit=$page_limit}

<div class="buttonblock">


{let user_class_group_id=ezini('UserSettings','UserClassGroupID')
     user_class_list_allowed=fetch('content','can_instantiate_classes')
     user_class_list=fetch('content','can_instantiate_class_list',hash(group_id,$user_class_group_id))}
{section show=$user_class_list_allowed}
    <form method="post" action={"content/action"|ezurl}>
         <select name="ClassID" class="classcreate">
	      {section name=Classes loop=$user_class_list}
	      <option value="{$:item.id}">{$:item.name}</option>
	      {/section}
         </select>
	 <br />
         <input type="hidden" name="BrowseNodeID" value="5" />
         <input class="classbutton" type="submit" name="NewButton" value="{'New'|i18n('design/standard/node/view')}" />
    </form>
{/section}
{/let}


<input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
<input type="hidden" name="ContentObjectID" value="{$content_object.id}" />
<input type="hidden" name="ViewMode" value="full" />

</div>

{/section}


{section show=$is_standalone}
</form>
{/section}

{/default}
{/let}
{/default}
