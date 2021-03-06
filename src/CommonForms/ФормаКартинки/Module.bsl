
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	Параметры.Свойство("НоменклатураСсылка", НоменклатураСсылка);	
	Параметры.Свойство("АдресХранилищаКартинки", АдресКартинка);	
	Параметры.Свойство("ЗаголовокКартинки", ЗаголовокКартинки);
	
	Если ЗначениеЗаполнено(НоменклатураСсылка) Тогда
		ПолучитьКартинкуПоСсылке(НоменклатураСсылка, Отказ);
	КонецЕсли;
	
	Элементы.ЗаголовокКартинки.Видимость = ЗначениеЗаполнено(ЗаголовокКартинки)
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьКартинкуПоСсылке(НоменклатураСсылка, Отказ)
	СоединениеИПараметры = ОбменДаннымиКлиентСервер.ПолучитьСоединениеИПараметры(ОбменДаннымиСервер.ПолучитьНастройкиСоединения());
	СтруктураОтвета = ОбменДаннымиКлиентСервер.ПолучитьКартинкуПоСсылке(НоменклатураСсылка, СоединениеИПараметры);
			
	Если СтруктураОтвета = Неопределено Тогда
		Отказ = Истина;
		Возврат;	
	КонецЕсли;	
	Если СтруктураОтвета.error Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтруктураОтвета.text;
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(СтруктураОтвета.data) Тогда
		АдресКартинка = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.НетИзображения);
		ЗаголовокКартинки = "Нет изображения";
	Иначе 
		АдресКартинка = ПоместитьВоВременноеХранилище(Base64Значение(СтруктураОтвета.data), УникальныйИдентификатор);
		ЗаголовокКартинки = Строка(НоменклатураСсылка);	
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти