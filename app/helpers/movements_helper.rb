module MovementsHelper
  def to_currency(number)
    number_to_currency(number, unit: "", precision: 0, format: "%u%n")
  end

  def to_hour(hour)
    eval(hour)[4].to_s + ':' + eval(hour)[5].to_s
  end

  def mov_types
    [['Ingreso', 'I'],
     ['Egreso', 'E'],
     ['Peajes', 'J'],

     ['Andaluz', 'Aª'],
     ['Datos_Móvil', 'A°'],
     ['Taller', 'T'],
     ['Varios', 'V'],
     ['---------------', ''],

     ['Home', 'H'],
     ['Personal', 'P'],
     ['Seg_Soc', 'S'],

     ['_________ Contab', ''],
     ['Débitos', 'D'],
     ['Créditos', 'C'],

     ['Préstamos', 'F¹'],
     ['Pagos', 'F²'],
     ['Prests_%', 'F³'],

     ['Impuestos', 'M'],
     ['Legal', 'L'],
     ['Otros', 'O'],

     ['________ Gts Fijos', ''],
     ['SOAT', 'S°'],
     ['Tarjeta_Operac', 'T°'],
     ['Taximetro', 'T×'],
     ['Téc_Méc', 'T™'],

     ['________ Financ', ''],
     ['Financiera', 'Fª'],
     ['Financ_%', 'F°'],
     ['Servicrédito', 'F×'],

     ['_________ Apart', ''],
     ['Bog1_Apartadó_Cons', 'Bª'],
     ['Bog1_Apartadó_Rets', 'Bº'],
     ['Bog1_Apartadó_Costos', 'Bæ'],

     ['_________ Med_Est', ''],
     ['Bog2_Estadio_Cons', 'Bd'],
     ['Bog2_Estadio_Rets', 'Bc'],
     ['Bog2_Estadio_Costos', 'ß'],

     ['_________ Bancos', ''],
     ['Bank_Dep', 'B¹'],
     ['Bank_Ret', 'B²'],
     ['Bank_CsF', 'B³'],
     ['Banks_vr', 'B°'],

     ['_________ STU379', ''],
     ['Ingreso9', 'I×'],
     ['Egreso9', 'E×'],
     ['Gst_Operac', 'O×'],
     ['Móvil Éxit9', 'A×'],
     ['Liquid9', 'L×'],
     ['Varios9', 'V×'],
     ['Taller9', 'U×'],

    ]

  end
end
