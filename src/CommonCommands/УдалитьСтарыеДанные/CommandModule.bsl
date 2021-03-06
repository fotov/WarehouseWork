
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	УдалитьСтарыеДанные();
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Данные удалены";
	Сообщение.Сообщить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьСтарыеДанные()
	РегистрыСведений.Сканирования.УдалитьСтарыеДанные();
	Документы.ОтборРазмещение.УдалитьСтарыеДанные();
	РегистрыСведений.РаботаСЯчейками.УдалитьСтарыеДанные();
КонецПроцедуры

#КонецОбласти
