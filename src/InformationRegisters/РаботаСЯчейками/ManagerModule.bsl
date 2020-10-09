Процедура ЗарегистрироватьРаботуСЯчейкой(Ячейка, Статус, Знач Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Попытка
			Пользователь = ПараметрыСеанса.ТекущийПользователь;
		Исключение
			Пользователь = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	МенЗаписи = РегистрыСведений.РаботаСЯчейками.СоздатьМенеджерЗаписи();
	МенЗаписи.Период = ТекущаяДата();
	МенЗаписи.Месяц = НачалоМесяца(МенЗаписи.Период);
	МенЗаписи.Пользователь = Пользователь;
	МенЗаписи.Ячейка = Ячейка;
	МенЗаписи.Статус = Статус;
	
	МенЗаписи.Записать(Истина);
КонецПроцедуры

Процедура УдалитьСтарыеДанные() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сканирования.Месяц КАК Месяц
		|ИЗ
		|	РегистрСведений.Сканирования КАК Сканирования
		|ГДЕ
		|	Сканирования.Месяц < &ДатаСреза
		|
		|СГРУППИРОВАТЬ ПО
		|	Сканирования.Месяц";
	
	Запрос.УстановитьПараметр("ДатаСреза", ДобавитьМесяц(ТекущаяДата(), -2));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборУдалить = РегистрыСведений.Сканирования.СоздатьНаборЗаписей();
		НаборУдалить.Отбор.Месяц.Установить(ВыборкаДетальныеЗаписи.Месяц);
		//НаборУдалить.Прочитать();
		НаборУдалить.Записать();
	КонецЦикла;
	
КонецПроцедуры