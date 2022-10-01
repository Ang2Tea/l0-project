PGDMP     	                    z            database_level0    14.5    14.5 $               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    24869    database_level0    DATABASE     l   CREATE DATABASE database_level0 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';
    DROP DATABASE database_level0;
                postgres    false            �            1259    24871 
   deliveries    TABLE     2  CREATE TABLE public.deliveries (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    phone character varying(14) NOT NULL,
    zip character varying NOT NULL,
    city character varying,
    address character varying NOT NULL,
    region character varying,
    email character varying
);
    DROP TABLE public.deliveries;
       public         heap    postgres    false            �            1259    24870    deliveries_id_seq    SEQUENCE     �   CREATE SEQUENCE public.deliveries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.deliveries_id_seq;
       public          postgres    false    210                       0    0    deliveries_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.deliveries_id_seq OWNED BY public.deliveries.id;
          public          postgres    false    209            �            1259    24880    items    TABLE     b  CREATE TABLE public.items (
    chrt_id integer NOT NULL,
    price integer NOT NULL,
    rid character varying NOT NULL,
    name character varying NOT NULL,
    sale integer NOT NULL,
    size character varying NOT NULL,
    total_price integer NOT NULL,
    nm_id integer NOT NULL,
    brand character varying NOT NULL,
    status integer NOT NULL
);
    DROP TABLE public.items;
       public         heap    postgres    false            �            1259    24879    items_id_seq    SEQUENCE     �   CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.items_id_seq;
       public          postgres    false    212                       0    0    items_id_seq    SEQUENCE OWNED BY     B   ALTER SEQUENCE public.items_id_seq OWNED BY public.items.chrt_id;
          public          postgres    false    211            �            1259    24915    order_items    TABLE     n   CREATE TABLE public.order_items (
    "order" character varying,
    item integer,
    id integer NOT NULL
);
    DROP TABLE public.order_items;
       public         heap    postgres    false            �            1259    24914    order_items_id_seq    SEQUENCE     �   CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.order_items_id_seq;
       public          postgres    false    216                       0    0    order_items_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;
          public          postgres    false    215            �            1259    24895    orders    TABLE     �  CREATE TABLE public.orders (
    order_uid character varying NOT NULL,
    track_number character varying,
    entry character varying,
    delivery integer,
    payment character varying,
    locale character varying,
    internal_signature character varying,
    customer_id character varying,
    delivery_service character varying,
    shardkey character varying,
    sm_id integer,
    date_created timestamp without time zone,
    oof_shard character varying
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    24888    payments    TABLE     C  CREATE TABLE public.payments (
    transaction character varying NOT NULL,
    request_id character varying,
    currency character varying,
    provider character varying,
    amount integer,
    payment_dt integer,
    bank character varying,
    delivery_cost integer,
    goods_total integer,
    custom_fee integer
);
    DROP TABLE public.payments;
       public         heap    postgres    false            n           2604    24874    deliveries id    DEFAULT     n   ALTER TABLE ONLY public.deliveries ALTER COLUMN id SET DEFAULT nextval('public.deliveries_id_seq'::regclass);
 <   ALTER TABLE public.deliveries ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209    210            o           2604    24883    items chrt_id    DEFAULT     i   ALTER TABLE ONLY public.items ALTER COLUMN chrt_id SET DEFAULT nextval('public.items_id_seq'::regclass);
 <   ALTER TABLE public.items ALTER COLUMN chrt_id DROP DEFAULT;
       public          postgres    false    212    211    212            p           2604    24918    order_items id    DEFAULT     p   ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);
 =   ALTER TABLE public.order_items ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    216    216                      0    24871 
   deliveries 
   TABLE DATA           X   COPY public.deliveries (id, name, phone, zip, city, address, region, email) FROM stdin;
    public          postgres    false    210   �*                 0    24880    items 
   TABLE DATA           i   COPY public.items (chrt_id, price, rid, name, sale, size, total_price, nm_id, brand, status) FROM stdin;
    public          postgres    false    212   +                 0    24915    order_items 
   TABLE DATA           8   COPY public.order_items ("order", item, id) FROM stdin;
    public          postgres    false    216   4+                 0    24895    orders 
   TABLE DATA           �   COPY public.orders (order_uid, track_number, entry, delivery, payment, locale, internal_signature, customer_id, delivery_service, shardkey, sm_id, date_created, oof_shard) FROM stdin;
    public          postgres    false    214   Q+                 0    24888    payments 
   TABLE DATA           �   COPY public.payments (transaction, request_id, currency, provider, amount, payment_dt, bank, delivery_cost, goods_total, custom_fee) FROM stdin;
    public          postgres    false    213   n+                  0    0    deliveries_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.deliveries_id_seq', 1, false);
          public          postgres    false    209                       0    0    items_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.items_id_seq', 1, false);
          public          postgres    false    211                       0    0    order_items_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);
          public          postgres    false    215            r           2606    24878    deliveries deliveries_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.deliveries DROP CONSTRAINT deliveries_pk;
       public            postgres    false    210            t           2606    24887    items items_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pk PRIMARY KEY (chrt_id);
 8   ALTER TABLE ONLY public.items DROP CONSTRAINT items_pk;
       public            postgres    false    212            v           2606    24894    payments newtable_pk 
   CONSTRAINT     [   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT newtable_pk PRIMARY KEY (transaction);
 >   ALTER TABLE ONLY public.payments DROP CONSTRAINT newtable_pk;
       public            postgres    false    213            |           2606    24922    order_items order_items_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_pk;
       public            postgres    false    216            x           2606    24901    orders orders_pk 
   CONSTRAINT     U   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pk PRIMARY KEY (order_uid);
 :   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pk;
       public            postgres    false    214            z           2606    24903    orders orders_un 
   CONSTRAINT     S   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_un UNIQUE (track_number);
 :   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_un;
       public            postgres    false    214                       2606    24923    order_items order_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_fk FOREIGN KEY ("order") REFERENCES public.orders(order_uid);
 D   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_fk;
       public          postgres    false    216    3192    214            �           2606    24928    order_items order_items_fk_1    FK CONSTRAINT     }   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_fk_1 FOREIGN KEY (item) REFERENCES public.items(chrt_id);
 F   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_fk_1;
       public          postgres    false    216    212    3188            ~           2606    25092    orders orders_fk    FK CONSTRAINT     {   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_fk FOREIGN KEY (payment) REFERENCES public.payments(transaction);
 :   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_fk;
       public          postgres    false    214    3190    213            }           2606    24909    orders orders_fk_1    FK CONSTRAINT     w   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_fk_1 FOREIGN KEY (delivery) REFERENCES public.deliveries(id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_fk_1;
       public          postgres    false    3186    214    210                  x������ � �            x������ � �            x������ � �            x������ � �            x������ � �     