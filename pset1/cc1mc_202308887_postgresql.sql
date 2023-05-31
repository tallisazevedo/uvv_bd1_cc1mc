                                                ------ Verificar se existe o banco de dados uvv, se houver a existência, será apagado ------

DROP DATABASE IF EXISTS uvv;

                                                ------ Verificar se existe a ROLE "tallis", se houver a existência, será apagado ------

DROP ROLE IF EXISTS tallis;

                                                ------ Verificar se existe o usuário "tallis", se houver a existência, será apagado ------

DROP USER IF EXISTS tallis;

                                                ------ Criação do usuário e senha criptografada ------

CREATE USER tallis WITH CREATEDB CREATEROLE ENCRYPTED PASSWORD 'computacao@raiz';

                                                ------ Criação da ROLE "tallis" ------

SET ROLE tallis;

                                                ------ Criação do banco de dados no usuário "tallis" -------
CREATE DATABASE uvv
    WITH 
    OWNER = tallis
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = true;

                                                ------ Comentário sobre o BANCO DE DADOS UVV ------

    COMMENT ON DATABASE uvv IS 'Banco de dados criado para ser usado em softwares que faça a gestão de lojas fisicas e onlines.';

                                                ------ Informando que a senha criptografada pode ser rodada de forma automática, sem que precise ser inserida de forma manual ------

\setenv PGPASSWORD computacao@raiz

                                                ------ Conexão com o banco de dados ------

\c uvv tallis;

                                                ------ Verificar se existe o schema "lojas", se houver a existência, será apagado ------

DROP SCHEMA IF EXISTS lojas;

                                                ------ Criação do SCHEMA ------ 

CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION tallis;

                                                ------ Comentário sobre o SCHEMA lojas ------

    COMMENT ON SCHEMA lojas IS 'O SCHEMA lojas é usado para comportar todos os objetos criados dentro do BANCO DE DADOS uvv.';

                                                ------ Alterar o banco de dados uvv e fazer a definição do search path ------

ALTER DATABASE uvv SET search_path TO "lojas", "$user", public;

SET SEARCH_PATH TO lojas, "$user", public;

                                                ------ Alterar o OWNER do SCHEMA lojas ------ 
ALTER SCHEMA lojas OWNER TO tallis;

                                                ------ Criação da tabela produtos ------

CREATE TABLE lojas.produtos (
                produto_id                  NUMERIC(38)     NOT NULL,
                nome                        VARCHAR(255)    NOT NULL,
                preco_unitario              NUMERIC(10,2),
                detalhes                    BYTEA,
                imagem                      BYTEA,
                imagem_mime_type            VARCHAR(512),
                imagem_arquivo              VARCHAR(512),
                imagem_charset              VARCHAR(512),
                imagem_ultima_atualizacao   DATE,
                CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);

                                                ------ Comentários da tabela e colunas relacionados a tabela produtos ------

COMMENT ON TABLE lojas.produtos IS                                      'Tabela para armazenar informações sobre os produtos.';
COMMENT ON COLUMN lojas.produtos.produto_id IS                          'Coluna para armazenar o número de identificação dos produtos.';
COMMENT ON COLUMN lojas.produtos.nome IS                                'Coluna para armazenar o nome dos produtos.';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS                      'Coluna para armazenar o preço dos produtos.';
COMMENT ON COLUMN lojas.produtos.detalhes IS                            'Coluna para armazenar os detalhes dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem IS                              'Coluna para armazenar as imagens dos produtos.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS                    'Coluna para armazenar o tipo da imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS                      'Coluna para armazenar o arquivo nomeado da imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS           'Coluna para armazenar a data de atualização das imagens.';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS                      'Coluna para armazenar o tipo de formato da logo.';

                                                ------ Criação da tabela lojas ------

CREATE TABLE lojas.lojas (
                loja_id                     NUMERIC(38)     NOT NULL,
                nome                        VARCHAR(255)    NOT NULL,
                endereco_web                VARCHAR(100),
                endereco_fisico             VARCHAR(512),
                latitude                    NUMERIC,
                longitude                   NUMERIC,
                logo                        BYTEA,
                logo_mime_type              VARCHAR(512),
                logo_arquivo                VARCHAR(512),
                logo_charset                VARCHAR(512),
                logo_ultima_atualizacao     DATE,
                CONSTRAINT lojas_pk PRIMARY KEY (loja_id)
);

                                                ------ Comentários da tabela e colunas relacionados a tabela lojas ------

COMMENT ON TABLE lojas.lojas IS                                 'Tabela para armazenar as informações das lojas.';
COMMENT ON COLUMN lojas.lojas.loja_id IS                        'Número de identificação das lojas.';
COMMENT ON COLUMN lojas.lojas.nome IS                           'Coluna para armazenar os nomes das lojas.';
COMMENT ON COLUMN lojas.lojas.endereco_web IS                   'Coluna para armazenar a URL do site da respectiva loja.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS                 'Coluna para armazenar os endereços físicos das lojas.';
COMMENT ON COLUMN lojas.lojas.latitude IS                       'Coluna para armazenar a latitude das lojas.';
COMMENT ON COLUMN lojas.lojas.longitude IS                      'Coluna para armazenar a longitude das lojas.';
COMMENT ON COLUMN lojas.lojas.logo IS                           'Coluna para armazenar as logos das lojas.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS                 'Coluna para armazenar o tipo de logo.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS                   'Coluna para armazenar o arquivo da logo das lojas.';
COMMENT ON COLUMN lojas.lojas.logo_charset IS                   'Coluna para armazenar o tipo de formato da logo.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS        'Coluna para armazenar a data de atualização das logos.';

                                                ------ Criação da tabela estoques ------

CREATE TABLE lojas.estoques (
                estoque_id      NUMERIC(38)     NOT NULL,
                loja_id         NUMERIC(38)     NOT NULL,
                produto_id      NUMERIC(38)     NOT NULL,
                quantidade      NUMERIC(38)     NOT NULL,
                CONSTRAINT estoques_pk PRIMARY KEY (estoque_id)
);

                                                ------ Comentários da tabela e colunas relacionados a tabela estoques ------

COMMENT ON TABLE lojas.estoques IS                  'Tabela para armazenar informações dos estoques.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS      'Coluna para armazenar o número de identificação do estoque.';
COMMENT ON COLUMN lojas.estoques.loja_id IS         'Coluna para armazenar o número de identificação das lojas.';
COMMENT ON COLUMN lojas.estoques.produto_id IS      'Coluna para armazenar o número de identificação do produtos.';
COMMENT ON COLUMN lojas.estoques.quantidade IS      'Coluna para armazenar a quantidade de produtoss que tem no estoque.';


                                                ------ Criação da tabela clientes ------

CREATE TABLE lojas.clientes (
                clientes        NUMERIC(38)     NOT NULL,
                email           VARCHAR(255)    NOT NULL,
                nome            VARCHAR(255)    NOT NULL,
                telefone1       VARCHAR(20),
                telefone2       VARCHAR(20),
                telefone3       VARCHAR(20),
                CONSTRAINT clientes_pk PRIMARY KEY (clientes)
);

                                                ------ Comentários da tabela e colunas relacionados a tabela clientes ------

COMMENT ON TABLE lojas.clientes IS                  'Tabela onde armazena as informações dos clientes.';
COMMENT ON COLUMN lojas.clientes.clientes IS        'Número de identificação do cliente.';
COMMENT ON COLUMN lojas.clientes.email IS           'Coluna de email dos clientes.';
COMMENT ON COLUMN lojas.clientes.nome IS            'Coluna para armazenar os nomes dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone1 IS       'Coluna para armazenar número de contato 1 dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone2 IS       'Coluna para armazenar número de contato 2 dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone3 IS       'Coluna para armazenar número de contato 3 dos clientes.';

                                                ------ Criação da tabela envios ------

CREATE TABLE lojas.envios (
                envio_id            NUMERIC(38)     NOT NULL,
                loja_id             NUMERIC(38)     NOT NULL,
                clientes_envios     NUMERIC(38)     NOT NULL,
                endereco_entrega    VARCHAR(512)    NOT NULL,
                status              VARCHAR(15)     NOT NULL,
                CONSTRAINT envios_pk PRIMARY KEY (envio_id)
);

                                                ------ Comentários da tabela e colunas relacionados a tabela envios  ------

COMMENT ON TABLE lojas.envios IS                        'Tabela de informações para envios.';
COMMENT ON COLUMN lojas.envios.envio_id IS              'Coluna onde armazena o número de identificação dos envios.';
COMMENT ON COLUMN lojas.envios.loja_id IS               'Número de identificação das lojas.';
COMMENT ON COLUMN lojas.envios.clientes_envios IS       'Coluna para armazenar o número de identificação dos clientes.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS      'Coluna onde armazena os endereços de entrega.';
COMMENT ON COLUMN lojas.envios.status IS                'Coluna onde se armazena os status dos envios.';

                                                ------ Criação da tabela pedidos------

CREATE TABLE lojas.pedidos (
                pedido_id       NUMERIC(38)     NOT NULL,
                data_hora       TIMESTAMP       NOT NULL,
                clientes_id     NUMERIC(38)     NOT NULL,
                status          VARCHAR(15)     NOT NULL,
                loja_id         NUMERIC(38)     NOT NULL,
                CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id)
);

                                                ------ Comentários da tabela e colunas relacionados a tabela envios ------

COMMENT ON TABLE lojas.pedidos IS                   'Tabela para armazenar as informações dos pedidos..';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS        'Coluna para armazenar o número de identificação do pedido.';
COMMENT ON COLUMN lojas.pedidos.data_hora IS        'Coluna para armazenar a data e hora que foram feito os pedidos.';
COMMENT ON COLUMN lojas.pedidos.clientes_id IS      'Número de identificação do cliente.';
COMMENT ON COLUMN lojas.pedidos.status IS           'Coluna para armazenar o status do pedido.';
COMMENT ON COLUMN lojas.pedidos.loja_id IS          'Número de identificação das lojas.';

                                                ------ Criação da tabela pedidos_itens ------

CREATE TABLE lojas.pedidos_itens (
                pedido_id           NUMERIC(38)     NOT NULL,
                produto_id          NUMERIC(38)     NOT NULL,
                numero_da_linha     NUMERIC(38)     NOT NULL,
                preco_unitario      NUMERIC(10,2)   NOT NULL,
                quantidade          NUMERIC(38)     NOT NULL,
                envio_id            NUMERIC(38),
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedido_id, produto_id)
);

                                                ------ Comentários da tabela e colunas relacionados a tabela envios ------

COMMENT ON TABLE lojas.pedidos_itens IS                     'Tabela para armazenar as informações dos itens de pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS          'Coluna para armazenar o número de identificação do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS         'Coluna para armazenar o número de identificação do produtos.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS    'Coluna onde os números de linha são armazenados.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS     'Coluna onde armazena os preços unitários da tabela pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS         'Coluna onde armazena a quantidade de itens pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS           'Coluna onde armazena o número de identificação dos envios.';




                                                ------ Criação das FK`s (FK -> PK) ------


ALTER TABLE lojas.estoques 
ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos 
ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.estoques 
ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.envios 
ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos 
ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (clientes_id)
REFERENCES lojas.clientes (clientes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.envios 
ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (clientes_envios)
REFERENCES lojas.clientes (clientes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

                                                ------ Criação das restrições de cada tabela ------


                                                ------ Criação das restrições da tabela produtos ------


ALTER TABLE lojas.produtos
ADD CONSTRAINT check_preco_unitario_produtos
CHECK (preco_unitario >= 0);

                                                ------ Criação das retrições da tabela lojas ------

ALTER TABLE lojas.lojas
ADD CONSTRAINT unico_nome_lojas
UNIQUE (nome);

ALTER TABLE lojas.lojas
ADD CONSTRAINT check_endereco_lojas
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

ALTER TABLE lojas.lojas 
ADD CONSTRAINT check_latitude_lojas
CHECK (latitude BETWEEN -90 AND 90);

ALTER TABLE lojas.lojas
ADD CONSTRAINT check_longitude_lojas
CHECK (longitude BETWEEN -180 AND 180);

                                                ------ Criação das restrições da tabela estoque ------

ALTER TABLE lojas.estoques
ADD CONSTRAINT check_quantidade_estoque
CHECK (quantidade >= 0);

                                                ------ Criação das restrições da tabela clientes ------

ALTER TABLE lojas.clientes 
ADD CONSTRAINT check_email_clientes
CHECK (email LIKE '%@%');

                                                ------ Criação das restrições da tabela pedidos ------ 

ALTER TABLE lojas.pedidos
ADD CONSTRAINT check_status_pedidos
CHECK (status IN ('CANCELADO','COMPLETO','ABERTO','PAGO','REEMBOLSADO','ENVIADO'));

                                                ------ Criação das restrições da tabela envios ------

ALTER TABLE lojas.envios 
ADD CONSTRAINT check_status_envios 
CHECK (status IN ('CRIADO', 'ENVIADO','TRANSITO','ENTREGUE'));
