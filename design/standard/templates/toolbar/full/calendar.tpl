{section show=or( $module_result.content_info.url_alias|begins_with( $show_subtree ),
                  eq( $module_result.content_info.class_identifier, $class_identifier ) )}

{let today_info=$view_parameters
     cache_keys=array( $today_info.year, $today_info.month, $today_info.day )
     time_start=false()
     time_end=false()
     time_published=false()
     time_current=false()}

{switch match=cond( and( $today_info, $today_info.year, $today_info.month, $today_info.day )|ne( false() ), 1,
                    and( $today_info, $today_info.year, $today_info.month )|ne( false() ), 2,
                    false() )}
{case match=1}
    {set time_start=maketime( 0, 0, 0, $today_info.month, 1, $today_info.year)
         time_end=maketime( 23, 59, 59, $today_info.month | inc, 0, $today_info.year )
         time_published=maketime( 0, 0, 0, $today_info.month, $today_info.day, $today_info.year )
         time_current=maketime( 0, 0, 0, $today_info.month, $today_info.day, $today_info.year )}
{/case}
{case match=2}
    {set cache_keys=array( $today_info.year, $today_info.month )
         time_start=maketime( 0, 0, 0, $today_info.month, 1, $today_info.year)
         time_end=maketime( 23, 59, 59, $today_info.month | inc, 0, $today_info.year )
         time_published=maketime( 0, 0, 0, $today_info.month, 1, $today_info.year )}
{/case}
{case}
    {set today_info=currentdate()|gettime
         time_start=maketime( 0, 0, 0, $today_info.month, 1, $today_info.year)
         time_end=maketime( 23, 59, 59, $today_info.month | inc, 0, $today_info.year )
         time_published=maketime( 0, 0, 0, $today_info.month, $today_info.day, $today_info.year )
         time_current=maketime( 0, 0, 0, $today_info.month, $today_info.day, $today_info.year )
         cache_keys=false()}
{/case}
{/switch}

{*{cache-block keys=$cache_keys}*}

<div class="toolbox">
    <div class="toolbox-design">
    <h2>Calendar</h2>

    <div class="toolbox-content">
    {let log_node_id=$module_result.content_info.node_id
         log_node=fetch( content, node, hash( node_id, $log_node_id ) )
         show_week=false()
         month_list=fetch( content, tree, hash( parent_node_id, $module_result.content_info.node_id,
                                                class_filter_type, include,
                                                class_filter_array, $class_identifier|explode( ',' ),
                                                attribute_filter, array( and, array( 'published', '>=',
                                                                                      $time_start ),
                                                                              array( 'published', '<=',
                                                                                      $time_end ) ),
                                                group_by, array( "published", "day" ),
                                                as_object, false() ) )
         month=$month_list|month_overview( 'published', $time_published,
                                           hash( current, $time_current,
                                                 current_class, 'selected',
                                                 today_class, 'today',
                                                 link, $log_node.url_alias,
                                                 month_link, true(), year_link, true(), day_link, true(),
                                                 next, hash( link, $log_node.url_alias ),
                                                 previous, hash( link, $log_node.url_alias ) ) )}
        {include name=Month uri="design:navigator/monthview.tpl" month=$month show_week=$show_week}
     {/let}

     </div>
     </div>
</div>


{*{cache-block}*}

{/let}

{/section}
