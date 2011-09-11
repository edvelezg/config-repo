
_form _edit_form {
   p_backcolor=0x80000005;
   p_border_style=BDS_DIALOG_BOX;
   p_caption='Open';
   p_clip_controls=false;
   p_forecolor=0x80000008;
   p_height=4950;
   p_help='Open dialog box';
   p_width=6990;
   p_x=1305;
   p_y=225;
   p_eventtab=_edit_form;
   _label label1 {
      p_alignment=AL_LEFT;
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='File &name';
      p_forecolor=0x80000008;
      p_height=195;
      p_tab_index=1;
      p_width=675;
      p_word_wrap=false;
      p_x=120;
      p_y=90;
   }
   _combo_box _openfn {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=FILE_ARG;
      p_forecolor=0x80000008;
      p_height=285;
      p_style=PSCBO_EDIT;
      p_tab_index=2;
      p_tab_stop=true;
      p_width=2520;
      p_x=120;
      p_y=330;
      p_eventtab=_open_form._openfn;
      p_eventtab2=_ul2_combobx;
   }
   _list_box _openfile_list {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_FIXED_SINGLE;
      p_forecolor=0x80000008;
      p_height=1815;
      p_multi_select=MS_NONE;
      p_scroll_bars=SB_VERTICAL;
      p_tab_index=3;
      p_tab_stop=true;
      p_width=2520;
      p_x=120;
      p_y=675;
      p_eventtab=_open_form._openfile_list;
      p_eventtab2=_ul2_fillist;
   }
   _label _opennofselected {
      p_alignment=AL_RIGHT;
      p_auto_size=false;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='';
      p_forecolor=0x80000008;
      p_height=240;
      p_tab_index=4;
      p_width=1740;
      p_word_wrap=false;
      p_x=660;
      p_y=2520;
   }
   _label label2 {
      p_alignment=AL_LEFT;
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='&Directories:';
      p_forecolor=0x80000008;
      p_height=195;
      p_tab_index=5;
      p_width=795;
      p_word_wrap=false;
      p_x=2760;
      p_y=105;
   }
   _list_box _opendir_list {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_FIXED_SINGLE;
      p_forecolor=0x80000008;
      p_height=1980;
      p_multi_select=MS_NONE;
      p_picture='_fldclos.bmp';
      p_pic_space_y=45;
      p_pic_point_scale=8;
      p_scroll_bars=SB_VERTICAL;
      p_tab_index=6;
      p_tab_stop=true;
      p_width=2640;
      p_x=2760;
      p_y=660;
      p_eventtab=_open_form._opendir_list;
      p_eventtab2=_ul2_dirlist;
   }
   _label _opencd {
      p_alignment=AL_LEFT;
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='_opencd';
      p_forecolor=0x80000008;
      p_height=195;
      p_tab_index=7;
      p_width=630;
      p_word_wrap=false;
      p_x=2760;
      p_y=375;
   }
   _label  {
      p_alignment=AL_LEFT;
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='List files of &type:';
      p_forecolor=0x80000008;
      p_height=195;
      p_tab_index=8;
      p_width=1125;
      p_word_wrap=false;
      p_x=120;
      p_y=2760;
   }
   _combo_box _openfile_types {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=NONE_ARG;
      p_forecolor=0x80000008;
      p_height=285;
      p_style=PSCBO_NOEDIT;
      p_tab_index=9;
      p_tab_stop=true;
      p_width=2280;
      p_x=120;
      p_y=2982;
      p_eventtab=_open_form._openfile_types;
      p_eventtab2=_ul2_combobx;
   }
   _label label4 {
      p_alignment=AL_LEFT;
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='Dri&ves:';
      p_forecolor=0x80000008;
      p_height=195;
      p_tab_index=10;
      p_width=495;
      p_word_wrap=false;
      p_x=2760;
      p_y=2700;
   }
   _combo_box _opendrives {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=NONE_ARG;
      p_forecolor=0x80000008;
      p_height=330;
      p_style=PSCBO_NOEDIT;
      p_tab_index=11;
      p_tab_stop=true;
      p_text='c:';
      p_width=2640;
      p_x=2760;
      p_y=2940;
      p_eventtab=_open_form._opendrives;
      p_eventtab2=_ul2_drvlist;
   }
   _command_button _openok {
      p_cancel=false;
      p_caption='&OK';
      p_default=true;
      p_height=372;
      p_tab_index=12;
      p_tab_stop=true;
      p_width=1320;
      p_x=5522;
      p_y=55;
   }
   _command_button _opencancel {
      p_cancel=true;
      p_caption='&Cancel';
      p_default=false;
      p_height=372;
      p_tab_index=13;
      p_tab_stop=true;
      p_width=1320;
      p_x=5520;
      p_y=480;
      p_eventtab=_open_form._opencancel;
   }
   _command_button _openfind_file {
      p_cancel=false;
      p_caption='Find Fi&le...';
      p_default=false;
      p_height=372;
      p_tab_index=14;
      p_tab_stop=true;
      p_width=1320;
      p_x=5520;
      p_y=900;
   }
   _check_box _openreadonly {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='&Read only';
      p_forecolor=0x80000008;
      p_height=240;
      p_style=PSCH_AUTO3STATEA;
      p_tab_index=15;
      p_tab_stop=true;
      p_value=2;
      p_width=1380;
      p_x=5520;
      p_y=1380;
   }
   _check_box _openchange_dir {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='Change di&r';
      p_forecolor=0x80000008;
      p_height=240;
      p_style=PSCH_AUTO2STATE;
      p_tab_index=16;
      p_tab_stop=true;
      p_value=0;
      p_width=1200;
      p_x=5520;
      p_y=1680;
   }
   _check_box _openkeep_old {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='&Keep old file';
      p_forecolor=0x80000008;
      p_height=240;
      p_style=PSCH_AUTO2STATE;
      p_tab_index=17;
      p_tab_stop=true;
      p_value=0;
      p_width=1440;
      p_x=5520;
      p_y=1980;
   }
   _command_button _openinvert {
      p_cancel=false;
      p_caption='&Invert';
      p_default=false;
      p_height=372;
      p_tab_index=19;
      p_tab_stop=true;
      p_visible=false;
      p_width=1368;
      p_x=5520;
      p_y=2520;
      p_eventtab=_open_form._openinvert;
   }
   _command_button _openadv {
      p_cancel=false;
      p_caption='&Advanced >>';
      p_default=false;
      p_height=372;
      p_tab_index=20;
      p_tab_stop=true;
      p_width=1368;
      p_x=5520;
      p_y=2940;
   }
   _check_box _openexpand {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='E&xpand tabs';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO3STATEA;
      p_tab_index=21;
      p_tab_stop=true;
      p_value=2;
      p_width=1476;
      p_x=120;
      p_y=3480;
   }
   _check_box _openlock {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='File loc&king';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO3STATEA;
      p_tab_index=22;
      p_tab_stop=true;
      p_value=2;
      p_width=1440;
      p_x=120;
      p_y=3780;
   }
   _check_box _openpreload {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='Preload file';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO3STATEA;
      p_tab_index=23;
      p_tab_stop=true;
      p_value=2;
      p_width=1368;
      p_x=120;
      p_y=4080;
   }
   _check_box _openbinary {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='&Binary';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO3STATEA;
      p_tab_index=24;
      p_tab_stop=true;
      p_value=2;
      p_width=1200;
      p_x=120;
      p_y=4380;
   }
   _check_box _opennewwin {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='New window';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO3STATEA;
      p_tab_index=25;
      p_tab_stop=true;
      p_value=2;
      p_width=1524;
      p_x=120;
      p_y=4680;
   }
   _frame  {
      p_backcolor=0x80000005;
      p_caption='File format';
      p_clip_controls=true;
      p_forecolor=0x80000008;
      p_height=1440;
      p_tab_index=26;
      p_width=4080;
      p_x=1680;
      p_y=3420;
      _radio_button _opendos {
         p_alignment=AL_LEFT;
         p_backcolor=0x80000005;
         p_caption='DOS';
         p_forecolor=0x80000008;
         p_height=262;
         p_tab_index=26;
         p_tab_stop=true;
         p_value=0;
         p_width=840;
         p_x=120;
         p_y=360;
      }
      _radio_button _openmac {
         p_alignment=AL_LEFT;
         p_backcolor=0x80000005;
         p_caption='Mac';
         p_forecolor=0x80000008;
         p_height=262;
         p_tab_index=27;
         p_tab_stop=true;
         p_value=0;
         p_width=840;
         p_x=960;
         p_y=360;
         p_eventtab=_edit_form._opendos;
      }
      _radio_button _openunix {
         p_alignment=AL_LEFT;
         p_backcolor=0x80000005;
         p_caption='UNIX';
         p_forecolor=0x80000008;
         p_height=262;
         p_tab_index=28;
         p_tab_stop=true;
         p_value=0;
         p_width=840;
         p_x=1800;
         p_y=360;
         p_eventtab=_edit_form._opendos;
      }
      _radio_button _openauto {
         p_alignment=AL_LEFT;
         p_backcolor=0x80000005;
         p_caption='Automatic';
         p_forecolor=0x80000008;
         p_height=262;
         p_tab_index=29;
         p_tab_stop=true;
         p_value=1;
         p_width=1200;
         p_x=2760;
         p_y=360;
         p_eventtab=_edit_form._opendos;
      }
      _label  {
         p_alignment=AL_RIGHT;
         p_auto_size=false;
         p_backcolor=0x80000005;
         p_border_style=BDS_NONE;
         p_caption='Line separator char (decimal)';
         p_forecolor=0x80000008;
         p_height=240;
         p_tab_index=30;
         p_width=2808;
         p_word_wrap=false;
         p_x=165;
         p_y=750;
      }
      _text_box _openlinesep {
         p_auto_size=true;
         p_backcolor=0x80000005;
         p_border_style=BDS_FIXED_SINGLE;
         p_completion=NONE_ARG;
         p_forecolor=0x80000008;
         p_height=255;
         p_tab_index=31;
         p_tab_stop=true;
         p_width=720;
         p_x=3240;
         p_y=720;
         p_eventtab2=_ul2_textbox;
      }
      _label  {
         p_alignment=AL_RIGHT;
         p_auto_size=false;
         p_backcolor=0x80000005;
         p_border_style=BDS_NONE;
         p_caption='Record width';
         p_forecolor=0x80000008;
         p_height=240;
         p_tab_index=32;
         p_width=2088;
         p_word_wrap=false;
         p_x=885;
         p_y=1110;
      }
      _text_box _openwidth {
         p_auto_size=true;
         p_backcolor=0x80000005;
         p_border_style=BDS_FIXED_SINGLE;
         p_completion=NONE_ARG;
         p_forecolor=0x80000008;
         p_height=255;
         p_tab_index=33;
         p_tab_stop=true;
         p_width=720;
         p_x=3240;
         p_y=1080;
         p_eventtab2=_ul2_textbox;
      }
   }
}
