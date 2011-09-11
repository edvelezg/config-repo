=surround_with_underline <u>%\m sur_text -select%</u>
=surround_with_blink <blink>%\m sur_text -select%</blink>
=surround_with_unordered_list <ul%\c>
                              %\m sur_text -indent%
                              </ul>
=surround_with_table_row <tr%\c>
                         %\m sur_text%
                         </tr>
=surround_with_italic <i>%\m sur_text -select%</i>
=surround_with_bold <b>%\m sur_text -select%</b>
=surround_with_table_data <td%\c>%\m sur_text -select%</td>
=surround_with_preformatted <pre>
                            %\m sur_text%
                            </pre>
=surround_with_unordered_list_with_li <ul>
                                      %\m sur_text -indent -begin <li> -end </li>%
                                      </ul>
=surround_with_link <a href="%\c">%\m sur_text%</a>
=surround_with_ordered_list <ol%\c>
                            %\m sur_text -indent%
                            </ol>
=surround_with_font <font %\c>%\m sur_text%</font>
=surround_with_heading_1 <h1>%\m sur_text%</h1>
=surround_with_ordered_list_with_li <ol%\c>
                                    %\m sur_text -indent -begin <li> -end </li>%
                                    </ol>
=surround_with_heading_2 <h2>%\m sur_text%</h2>
=surround_with_definition_list_definition <dd>
                                          %\m sur_text -indent%
                                          </dd>
=surround_with_heading_3 <h3>%\m sur_text%</h3>
=surround_with_heading_4 <h4>%\m sur_text%</h4>
=surround_with_paragraph <p>%\m sur_text%</p>
=surround_with_list_item <li>%\m sur_text -select%</li>
=surround_with_definition_list_term <dt>%\m sur_text%</dt>
=surround_with_heading_5 <h5>%\m sur_text%</h5>
=surround_with_table <table%\c>
                     %\m sur_text -indent%
                     </table>
=surround_with_heading_6 <h6>%\m sur_text%</h6>
=surround_with_anchor <a name=%\c>%\m sur_text -select%</a>
=surround_with_general_tag(tag "Tag" 
                           )
 <%(tag)%\c>%\m sur_text%</%(tag)>
=surround_with_definition_list <dl>
                               %\m sur_text -indent%
                               </dl>
=surround_with_emphasis <em>%\m sur_text -select%</em>
