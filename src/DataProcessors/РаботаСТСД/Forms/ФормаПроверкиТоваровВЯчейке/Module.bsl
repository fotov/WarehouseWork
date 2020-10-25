#Область ОписаниеПеременных

&НаКлиенте
Перем НомерУстройства, СоединениеИПараметры;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СканШтрихкода"
		И (НомерУстройства = Источник ИЛИ Источник = ЭтаФорма)
		И ВводДоступен() Тогда

		ШтрихкодПоиск = Параметр;

		ОбработатьШтрихкод(Параметр); //процедура для обработки ШК

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)	
	Если КомпонентыДляСчитыванияШтрихкодов <> Неопределено Тогда
		КомпонентыДляСчитыванияШтрихкодов.Подключить(НомерУстройства);
	КонецЕсли;
	
	НастройкиСоединения = ПолучитьНастройкиСоединения();
	СоединениеИПараметры = ОбменДаннымиКлиентСервер.ПолучитьСоединениеИПараметры(НастройкиСоединения);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если КомпонентыДляСчитыванияШтрихкодов <> Неопределено Тогда
	
		КомпонентыДляСчитыванияШтрихкодов.Отключить(НомерУстройства);
	
	КонецЕсли;
	
	СоединениеИПараметры = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	ОбработатьШтрихкод(ШтрихкодПоиск);
КонецПроцедуры

&НаКлиенте
Процедура ЯчейкаПриИзменении(Элемент)
	ВывестиИнформациюНаличиюТовара();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьДанныеПоШтрихкоду(ШтрихкодаСтрока)
	
	АдресРесурсаСПараметрами = СоединениеИПараметры.Параметры.АдресРесурса + "/infoOnBarcode?barcode=" + СокрЛП(ШтрихкодаСтрока);
	
	СтруктураОтвета = ОбменДаннымиКлиентСервер.ПолучитьОтвет(СоединениеИПараметры, АдресРесурсаСПараметрами, "GET");
	
	Если СтруктураОтвета = Неопределено Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	Если СтруктураОтвета.error Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка в запросе: " + СтруктураОтвета.text;
		Сообщение.Сообщить();
	
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат СтруктураОтвета;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкод(Штрихкод)
	
	Если НЕ ЗначениеЗаполнено(Штрихкод) Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписатьСканированиеШтрихкода(Штрихкод);
	
	ДанныеШтрихкода = ПолучитьДанныеШтрихкодаСервер(Штрихкод, КэшированныеЗначения);
	
	Если ТипЗнч(ДанныеШтрихкода) = Тип("СправочникСсылка.Ячейки") Тогда	
		Ячейка = ДанныеШтрихкода;
		Возврат;
	КонецЕсли;
	
	СтруктураОтвета = ПолучитьДанныеПоШтрихкоду(Штрихкод);
	Если СтруктураОтвета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураОтвета.data = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураОтвета.Свойство("type") Тогда
		
		СтруктураОтвета = ОбработатьРезультат(СтруктураОтвета);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураОтвета.data); 
		
		ИнфоПоОстаткам.Очистить();
		Для Каждого ТекЗапись Из СтруктураОтвета.remnant Цикл
			
			НовСтрока = ИнфоПоОстаткам.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, ТекЗапись);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ВывестиИнформациюНаличиюТовара();	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Попытка
		ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	Исключение
	КонецПопытки;
	
	КэшированныеЗначения = Новый Структура;
	КэшированныеЗначения.Вставить("Штрихкоды", Новый Соответствие);	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиСоединения()
	
	Возврат ОбменДаннымиСервер.ПолучитьНастройкиСоединения();	//ПользователиИнформационнойБазы.ТекущийПользователь()
	
КонецФункции

&НаСервере
Функция ОбработатьРезультат(СтруктураОтвета)
	
	СтруктураРезультат = Новый Структура("data, remnant", Новый Структура, Новый Массив);
	
	Если СтруктураОтвета.data.Свойство("Номенклатура") Тогда
		СтруктураРезультат.data.Вставить("Номенклатура", ОбменДаннымиСервер.ПолучитьСоздатьОбновитьСсылку(СтруктураОтвета.data.Номенклатура, "Номенклатура", Ложь));	
	КонецЕсли;
	Если СтруктураОтвета.data.Свойство("Упаковка") Тогда
		СтруктураРезультат.data.Вставить("Упаковка", ОбменДаннымиСервер.ПолучитьСоздатьОбновитьСсылку(СтруктураОтвета.data.Упаковка, "Упаковки", Ложь));	
	КонецЕсли;
	Если СтруктураОтвета.data.Свойство("Ячейка") Тогда
		СтруктураРезультат.data.Вставить("Ячейка", ОбменДаннымиСервер.ПолучитьСоздатьОбновитьСсылку(СтруктураОтвета.data.Ячейка, "Ячейки", Ложь));	
	КонецЕсли;
	
	Для Каждого ТекСтрока Из СтруктураОтвета.remnant Цикл
		СтруктураСтроки = Новый Структура("Номенклатура, Ячейка, Упаковка, ВНаличииОстаток, ВНаличииОстатокШтуки");
		СтруктураСтроки.Номенклатура = ОбменДаннымиСервер.ПолучитьСоздатьОбновитьСсылку(ТекСтрока.Номенклатура, "Номенклатура", Ложь);
		СтруктураСтроки.Ячейка = ОбменДаннымиСервер.ПолучитьСоздатьОбновитьСсылку(ТекСтрока.Ячейка, "Ячейки", Ложь);
		СтруктураСтроки.Упаковка = ОбменДаннымиСервер.ПолучитьСоздатьОбновитьСсылку(ТекСтрока.Упаковка, "Упаковки", Ложь);
		СтруктураСтроки.ВНаличииОстаток = ТекСтрока.ВНаличииОстаток;
		СтруктураСтроки.ВНаличииОстатокШтуки = ТекСтрока.ВНаличииОстаток * ?(СтруктураСтроки.Упаковка.Знаменатель = 0, 1, СтруктураСтроки.Упаковка.Числитель/СтруктураСтроки.Упаковка.Знаменатель);
		
		Если ТекСтрока.Свойство("ВидЯчейки") Тогда  
			СтруктураСтроки.Вставить("ВидЯчейки", ТекСтрока.ВидЯчейки);
		КонецЕсли;
		
		СтруктураРезультат.remnant.Добавить(СтруктураСтроки);
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ЗаписатьСканированиеШтрихкода(Штрихкод)
	
	РегистрыСведений.Сканирования.ЗарегистрироватьВводШтрихкода(Штрихкод);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюНаличиюТовара()
	Если НЕ ЗначениеЗаполнено(Ячейка)
		ИЛИ НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		
		СтрокаИнформация = "";
		Элементы.СтрокаИнформация.ЦветФона = WebЦвета.Белый;		
		Возврат;
	КонецЕсли;
	
	СтрокиСЯчейкой = ИнфоПоОстаткам.НайтиСтроки(Новый Структура("Ячейка", Ячейка));
 	Если СтрокиСЯчейкой.Количество() > 0 Тогда
		СтрокаДанных = СтрокиСЯчейкой[0];
		СтрокаИнформация = "В ячейке: " + СтрокаДанных.ВНаличииОстаток + " " + СтрокаДанных.Упаковка;
		Элементы.СтрокаИнформация.ЦветФона = WebЦвета.БледноЗеленый;
	Иначе 
		СтрокаИнформация = "Товара нет в ячейке!";
		Элементы.СтрокаИнформация.ЦветФона = WebЦвета.СветлоКоралловый;		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеШтрихкодаСервер(Штрихкод, КэшированныеЗначения)	
	ДанныеШтрихкода = КэшированныеЗначения.Штрихкоды.Получить(Штрихкод);
	
	Если ДанныеШтрихкода = Неопределено Тогда 
		ДанныеШтрихкода = Штрихкодирование.ПолучитьДанныеПоШтрихкоду(Штрихкод, КэшированныеЗначения);
	КонецЕсли;
	
	Возврат ДанныеШтрихкода;
КонецФункции

#КонецОбласти
