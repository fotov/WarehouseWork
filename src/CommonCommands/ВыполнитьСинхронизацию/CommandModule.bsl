#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Синхронизировать();
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Синхронизация завершена";
	Сообщение.Сообщить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Синхронизировать()
	ОбменДаннымиСервер.Синхронизировать();
КонецПроцедуры

#КонецОбласти

