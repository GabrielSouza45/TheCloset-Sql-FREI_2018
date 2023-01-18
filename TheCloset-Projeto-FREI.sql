drop database TheCloset;
create database TheCloset;
use TheCloset;

CREATE TABLE `tb_Cliente` (
	`id_Cliente` INT NOT NULL AUTO_INCREMENT,
	`nm_Cliente` varchar(45) NOT NULL,
	`ds_CPF` varchar(15) NOT NULL,
	`ds_Telefone` varchar(45) NOT NULL,
	`ds_Celular` varchar(45) NOT NULL,
	`id_Endereco` INT NULL,
	`ds_Login` varchar(45) NOT NULL,
	`ds_Senha` varchar(15) NOT NULL,
	`bt_adm` boolean default false,
	PRIMARY KEY (`id_Cliente`)
);

CREATE TABLE `tb_Pedido` (
	`id_Pedido` INT NOT NULL AUTO_INCREMENT,
	`id_Cliente` INT NOT NULL,
	`dt_Venda` DATETIME NOT NULL,
	
	PRIMARY KEY (`id_Pedido`)
);

create TABLE `tb_Produto` (
	`id_Produto` INT NOT NULL AUTO_INCREMENT,
	`nm_Produto` varchar(55) NOT NULL,
	`vl_Preco` DECIMAL(7,2) NOT NULL,
	`id_Fornecedor` INT NOT NULL,
    `id_Pedido_Item` int null,
	PRIMARY KEY (`id_Produto`)
);
     
CREATE TABLE `tb_Pedido_Item` (
	`id_Pedido_Item` INT NOT NULL AUTO_INCREMENT,
	`id_Pedido` INT NOT NULL,
	`id_Produto` INT NOT NULL,
	PRIMARY KEY (`id_Pedido_Item`)
);

CREATE TABLE `tb_Fornecedor` (
	`id_Fornecedor` INT NOT NULL AUTO_INCREMENT,
	`nm_Fornecedor` varchar(45) NOT NULL,
    `ds_Endereco` varchar(55) NOT NULL,
	`ds_Telefone` varchar(45) NOT NULL,
    
	PRIMARY KEY (`id_Fornecedor`)
);

CREATE TABLE `tb_Endereco` (
	`id_Endereco` INT NOT NULL AUTO_INCREMENT,
	`nm_Cidade` varchar(55) NOT NULL,
	`nm_Estado` varchar(55) NOT NULL,
	`ds_CEP` varchar(9) NOT NULL,
	`ds_Rua` VARCHAR(55) NOT NULL,
	`ds_NumeroCasa` INT(9) NOT NULL,
	PRIMARY KEY (`id_Endereco`)
);

CREATE TABLE `tb_Entrega` (
	`id_Entrega` INT NOT NULL AUTO_INCREMENT,
	`id_Pedido` INT NOT NULL,
	`id_Endereco` INT NOT NULL,
    `id_Cliente` INT NOT NULL,
	PRIMARY KEY (`id_Entrega`)
);

ALTER TABLE `tb_Cliente` ADD CONSTRAINT `tb_Cliente_fk0` FOREIGN KEY (`id_Endereco`) REFERENCES `tb_Endereco`(`id_Endereco`);

ALTER TABLE `tb_Pedido` ADD CONSTRAINT `tb_Pedido_fk0` FOREIGN KEY (`id_Cliente`) REFERENCES `tb_Cliente`(`id_Cliente`);

ALTER TABLE `tb_Produto` ADD CONSTRAINT `tb_Produto_fk0` FOREIGN KEY (`id_Fornecedor`) REFERENCES `tb_Fornecedor`(`id_Fornecedor`);

ALTER TABLE `tb_Pedido_Item` ADD CONSTRAINT `tb_Pedido_Item_fk0` FOREIGN KEY (`id_Pedido`) REFERENCES `tb_Pedido`(`id_Pedido`);

ALTER TABLE `tb_Pedido_Item` ADD CONSTRAINT `tb_Pedido_Item_fk1` FOREIGN KEY (`id_Produto`) REFERENCES `tb_Produto`(`id_Produto`);

ALTER TABLE `tb_Entrega` ADD CONSTRAINT `tb_Entrega_fk0` FOREIGN KEY (`id_Pedido`) REFERENCES `tb_Pedido`(`id_Pedido`);

ALTER TABLE `tb_Entrega` ADD CONSTRAINT `tb_Entrega_fk1` FOREIGN KEY (`id_Endereco`) REFERENCES `tb_Endereco`(`id_Endereco`);

ALTER TABLE `tb_Entrega` ADD CONSTRAINT `tb_Entrega_fk2` FOREIGN KEY (`id_Cliente`) REFERENCES `tb_Cliente`(`id_Cliente`);


INSERT INTO `thecloset`.`tb_cliente`
(`nm_Cliente`,
`ds_CPF`,
`ds_Telefone`,
`ds_Celular`,
`id_Endereco`,
`ds_Login`,
`ds_Senha`,
`bt_adm`)
VALUES
('adm', '','','', null,'admin','admin', true);



CREATE VIEW vw_pedido_consultar AS 
	SELECT tb_pedido.id_pedido,
		   tb_cliente.nm_cliente,
           tb_pedido.dt_venda,
		   count(tb_pedido_item.id_pedido_item) 	as qtd_itens,
           sum(tb_produto.vl_preco)		 			as vl_total
      FROM tb_pedido
      JOIN tb_pedido_item
        ON tb_pedido.id_pedido = tb_pedido_item.id_pedido
	  JOIN tb_produto
        ON tb_pedido_item.id_produto = tb_produto.id_produto
	  JOIN tb_cliente
        ON tb_cliente.id_cliente = tb_pedido.id_cliente
	 GROUP 
	    BY tb_pedido.id_pedido,
		   tb_cliente.nm_cliente,
           tb_pedido.dt_venda;
           
           
           
create VIEW VW_PRODUTO_CONSULTA AS
	select tb_produto.id_produto,
		   tb_produto.nm_produto,
		   tb_produto.vl_preco,
		   tb_fornecedor.nm_fornecedor
	  from tb_produto
	  join tb_fornecedor
		on tb_produto.id_fornecedor = tb_fornecedor.id_fornecedor;
        
CREATE VIEW VW_ENTREGAS_CONSULTAR AS
	select tb_Entrega.id_Entrega,
		   tb_cliente.id_cliente,
		   tb_cliente.nm_cliente,
           tb_cliente.ds_telefone,
           tb_Endereco.nm_Cidade,
           tb_Endereco.ds_Rua,
           tb_Endereco.ds_cep,
           tb_Endereco.ds_numerocasa,
           tb_pedido.id_pedido
	from tb_Entrega
    join tb_cliente
      on tb_Entrega.id_cliente = tb_cliente.id_cliente  
	join tb_Endereco
	  on tb_Entrega.id_endereco = tb_endereco.id_endereco
	join tb_pedido
	  on tb_Entrega.id_pedido = tb_pedido.id_pedido;
      
           

use TheCloset;

select * from tb_cliente;
select * from tb_fornecedor;
select * from tb_Pedido;
select * from tb_Produto;
select * from tb_Pedido_Item;
select * from tb_Endereco;
select * from tb_Entrega;
