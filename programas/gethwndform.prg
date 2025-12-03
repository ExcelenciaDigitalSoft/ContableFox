LParameter toForm
Local lcCaption
lcCaption = toForm.Caption
toForm.Caption = Sys(3)
Local lnHWND
lnHWND = _WhToHwnd( _WFindTitl(toForm.Caption) )
toForm.Caption = m.lcCaption
Return m.lnHWND
