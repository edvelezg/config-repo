indexterm1(description "Description" 
           )
 <indexterm %\m create_docbook_id%>
 %\i<primary>%(description)</primary>
 </indexterm>
indexterm2(category "Category" 
           description "Description"
           )
 <indexterm %\m create_docbook_id%>
 %\i<primary>%(category)</primary>
 %\i<secondary>%(description)</secondary>
 </indexterm>
emphasis <emphasis role="bold">%\c</emphasis>
orderedlist <orderedlist>
            %\i<listitem>
            %\i%\i<para role="NormalText">%\c</para>
            %\i</listitem>
            %\i<listitem>
            %\i%\i<para role="NormalText"></para>
            %\i</listitem>
            </orderedlist>
url(url "URL" 
    name "Name"
    )
 <ulink url="%(url)"><citetitle>%(name)</citetitle></ulink>
superscript <superscript>%\c</superscript>
listitem <listitem>
         %\i<para role="NormalText">%\c</para>
         </listitem>
image(filename "File name" 
      filetype "File type (jpg, gif, png)"
      width "Width"
      height "Height"
      )
 <mediaobject>
 %\i<imageobject>
 %\i%\i<imagedata fileref="Resources/%(filename)" format="%(filetype)" width="%(width)px" depth="%(height)px" />
 %\i</imageobject>
 </mediaobject>
table <table %\m create_docbook_id%>
      %\i<tgroup cols="2">
      %\i%\i<thead>
      %\i%\i%\i<row>
      %\i%\i%\i%\i<entry>
      %\i%\i%\i%\i%\i<para role="CellHeading">Column 1</para>
      %\i%\i%\i%\i</entry>
      %\i%\i%\i%\i<entry>
      %\i%\i%\i%\i%\i<para role="CellHeading">Column 2</para>
      %\i%\i%\i%\i</entry>
      %\i%\i%\i</row>
      %\i%\i</thead>
      %\i%\i<tbody>
      %\i%\i%\i<row>
      %\i%\i%\i%\i<entry>
      %\i%\i%\i%\i%\i<para role="CellBody">
      %\i%\i%\i%\i%\i%\i%\c
      %\i%\i%\i%\i%\i</para>
      %\i%\i%\i%\i</entry>
      %\i%\i%\i%\i<entry>
      %\i%\i%\i%\i%\i<para role="CellBody">
      %\i%\i%\i%\i%\i</para>
      %\i%\i%\i%\i</entry>
      %\i%\i%\i</row>
      %\i%\i</tbody>
      %\i</tgroup>
      </table>
tip <tip>
    %\i<para role="CellBody">%\c</para>
    </tip>
anchor(name "Name" 
       )
 <anchor xreflabel="%(name)" %\m create_docbook_id% />
italics <emphasis>%\c</emphasis>
bold <emphasis role="bold">%\c</emphasis>
command <command>%\c</command>
guilabel <guilabel>%\c</guilabel>
comment <!--
        %\c
        -->
note <note>
     %\i<para role="CellBody">%\c</para>
     </note>
warning <warning>
        %\i<para role="CellBody">%\c</para>
        </warning>
subscript <subscript>%\c</subscript>
code <programlisting>
     %\c
     </programlisting>
caution <caution>
        %\i<para role="CellBody">%\c</para>
        </caution>
guibutton <guibutton>%\c</guibutton>
xref(id "ID" 
     )
 <xref linkend="%(id)" />
para <para role="NormalText">%\c</para>
sect1(name "Name" 
      )
 <sect1 xreflabel="%(name)" %\m create_docbook_id%>
 %\i<title role="SectionHeading1">%(name)</title>
 %\i<para role="NormalText">%\c</para>
 </sect1>
sect2(name "Name" 
      )
 <sect2 xreflabel="%(name)" %\m create_docbook_id%>
 %\i<title role="SectionHeading2">%(name)</title>
 %\i<para role="NormalText">%\c</para>
 </sect2>
sect3(name "Name" 
      )
 <sect3 xreflabel="%(name)" %\m create_docbook_id%>
 %\i<title role="SectionHeading3">%(name)</title>
 %\i<para role="NormalText">%\c</para>
 </sect3>
sect4(name "Name" 
      )
 <sect4 xreflabel="%(name)" %\m create_docbook_id%>
 %\i<title role="SectionHeading4">%(name)</title>
 %\i<para role="NormalText">%\c</para>
 </sect4>
itemizedlist <itemizedlist>
             %\i<listitem>
             %\i%\i<para role="NormalText">%\c</para>
             %\i</listitem>
             %\i<listitem>
             %\i%\i<para role="NormalText">%\c</para>
             %\i</listitem>
             </itemizedlist>
filename <filename>%\c</filename>
sect5(name "Name" 
      )
 <sect5 xreflabel="%(name)" %\m create_docbook_id%>
 %\i<title role="SectionHeading5">%(name)</title>
 %\i<para role="NormalText">%\c</para>
 </sect5>
icon(filename "File name" 
     filetype "File type (jpg, gif, png)"
     width "Width"
     height "Height"
     )
 <inlinemediaobject>
 %\i<imageobject>
 %\i%\i<imagedata fileref="Resources/%(filename)" format="%(filetype)" width="%(width)px" depth="%(height)px" />
 %\i</imageobject>
 </inlinemediaobject>
keycombo(key1 "Key 1" 
         key2 "Key 2"
         )
 <keycombo action="simul"><keycap>%(key1) </keycap><keycap>%(key2) </keycap></keycombo>
options(topmenu "Option Node" 
        submenu "Option Leaf"
        )
 <menuchoice><guimenu>Tools </guimenu><guimenuitem> Options</guimenuitem><guimenuitem> %(topmenu)</guimenuitem><guimenuitem> %(submenu)</guimenuitem></menuchoice>
menu(topmenu "Top menu" 
     submenu "Sub menu"
     )
 <menuchoice><guimenu>%(topmenu) </guimenu><guimenuitem>%(submenu) </guimenuitem></menuchoice>
