#include "slick.sh"

_form _open_form {
   p_backcolor=0x80000005;
   p_border_style=BDS_DIALOG_BOX;
   p_caption='Open';
   p_clip_controls=false;
   p_forecolor=0x80000008;
   p_height=9375;
   p_help='Standard Open dialog box';
   p_width=12945;
   p_x=7095;
   p_y=525;
   p_eventtab=_open_form;
   _label  {
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
      p_y=120;
   }
   _combo_box _openfn {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=FILE_ARG;
      p_forecolor=0x80000008;
      p_height=315;
      p_style=PSCBO_EDIT;
      p_tab_index=2;
      p_tab_stop=true;
      p_width=5520;
      p_x=120;
      p_y=360;
      p_eventtab2=_ul2_combobx;
   }
   _list_box _openfile_list {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_FIXED_SINGLE;
      p_forecolor=0x80000008;
      p_height=7815;
      p_multi_select=MS_NONE;
      p_scroll_bars=SB_VERTICAL;
      p_tab_index=3;
      p_tab_stop=true;
      p_width=5520;
      p_x=120;
      p_y=690;
      p_eventtab2=_ul2_fillist;
   }
   _label _opennofselected {
      p_alignment=AL_RIGHT;
      p_auto_size=false;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='_opennofselected';
      p_forecolor=0x80000008;
      p_height=240;
      p_tab_index=4;
      p_width=1740;
      p_word_wrap=false;
      p_x=660;
      p_y=8520;
   }
   _label  {
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
      p_x=5760;
      p_y=120;
   }
   _list_box _opendir_list {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_FIXED_SINGLE;
      p_forecolor=0x80000008;
      p_height=7980;
      p_multi_select=MS_NONE;
      p_picture='_fldclos.bmp';
      p_pic_space_y=45;
      p_pic_point_scale=8;
      p_scroll_bars=SB_VERTICAL;
      p_tab_index=6;
      p_tab_stop=true;
      p_width=5640;
      p_x=5760;
      p_y=660;
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
      p_x=5760;
      p_y=390;
   }
   _label ctllistfiles_of_type {
      p_alignment=AL_LEFT;
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='List files of &type:';
      p_forecolor=0x80000008;
      p_height=195;
      p_tab_index=8;
      p_width=4125;
      p_word_wrap=false;
      p_x=120;
      p_y=8730;
   }
   _combo_box _openfile_types {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=NONE_ARG;
      p_forecolor=0x80000008;
      p_height=315;
      p_style=PSCBO_NOEDIT;
      p_tab_index=9;
      p_tab_stop=true;
      p_width=5520;
      p_x=120;
      p_y=8982;
      p_eventtab2=_ul2_combobx;
   }
   _label  {
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
      p_x=5760;
      p_y=8700;
   }
   _combo_box _opendrives {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=NONE_ARG;
      p_forecolor=0x80000008;
      p_height=360;
      p_style=PSCBO_NOEDIT;
      p_tab_index=11;
      p_tab_stop=true;
      p_text='j:';
      p_width=5640;
      p_x=5760;
      p_y=8940;
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
      p_x=11520;
      p_y=60;
   }
   _command_button _opencancel {
      p_cancel=true;
      p_caption='&Cancel';
      p_default=false;
      p_height=372;
      p_tab_index=13;
      p_tab_stop=true;
      p_width=1320;
      p_x=11520;
      p_y=480;
   }
   _command_button ctlhelp {
      p_cancel=false;
      p_caption='&Help';
      p_default=false;
      p_height=372;
      p_tab_index=14;
      p_tab_stop=true;
      p_width=1320;
      p_x=11520;
      p_y=900;
   }
   _check_box _openreadonly {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='&Read only';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO3STATEA;
      p_tab_index=15;
      p_tab_stop=true;
      p_value=2;
      p_width=1380;
      p_x=11520;
      p_y=1380;
   }
   _check_box _openchange_dir {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='Change di&r';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO2STATE;
      p_tab_index=16;
      p_tab_stop=true;
      p_value=0;
      p_width=1200;
      p_x=11520;
      p_y=1680;
   }
   _check_box _openkeep_old {
      p_alignment=AL_LEFT;
      p_backcolor=0x80000005;
      p_caption='&Keep old file';
      p_forecolor=0x80000008;
      p_height=262;
      p_style=PSCH_AUTO2STATE;
      p_tab_index=17;
      p_tab_stop=true;
      p_value=0;
      p_width=1440;
      p_x=11520;
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
      p_width=1320;
      p_x=11520;
      p_y=2520;
   }
}

