create database DBTeam;

use DBTeam;

create table libros(
   codigo int identity,
   titulo varchar(40),
   autor varchar(30),
   editorial varchar(20),
   precio decimal(5,2),
   cantidad smallint,
   primary key(codigo)
  )  ;

  create proc sp_listar_libros
  as
  select * from libros order by codigo;

  create proc sp_buscar_libros
  @titulo varchar(80)
  as
  select codigo, titulo, precio, autor, editorial, cantidad  from libros where titulo like @titulo + '%'; 

  create proc sp_mantenimiento_libros
  @codigo varchar(5),
  @titulo varchar(80),
  @autor varchar(50),
  @editorial varchar(50),
  @precio int,
  @cantidad int,
  @accion varchar(50) output
  as
  if(@accion='1')
  begin
	declare  @codnuevo varchar(5), @codmax varchar(5)
	set @codmax = (select max(codigo) from libros)
	set @codmax = isnull(@codmax, 'A0000')
	set @codnuevo ='A'+RIGHT(RIGHT(@codmax,4)+10001,4)
	insert into libros(codigo,titulo,autor,editorial,precio,cantidad)
	values(@codnuevo,@titulo,@autor,@editorial,@precio, @cantidad)
	set  @accion='se genero el codigo : '+@codnuevo
  end
  else if  (@accion='2')
  begin
	update libros set titulo=@titulo, autor=@autor, editorial=@editorial, precio=@precio, cantidad=@cantidad where codigo=@codigo
	set @accion = 'se modifico el codigo: '+@codigo
	end
else if (@accion = '3')
begin 
	delete from libros where codigo=@codigo
	set @accion='se borro el código: '+@codigo
end ;

