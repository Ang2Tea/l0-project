--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2022-10-03 09:47:13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 216 (class 1255 OID 25108)
-- Name: insert_item(integer, integer, character varying, character varying, integer, character varying, integer, integer, character varying, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_item(IN chrt_id integer, IN price integer, IN rid character varying, IN name character varying, IN sale integer, IN size character varying, IN total_price integer, IN nm_id integer, IN brand character varying, IN status integer)
    LANGUAGE plpgsql
    AS $$
	begin
		INSERT INTO public.items (chrt_id, price, rid, "name", sale, "size", total_price, nm_id, brand, status) 
		VALUES(chrt_id, price, rid, "name", sale, "size", total_price , nm_id , brand, status);
	END;
$$;


--
-- TOC entry 217 (class 1255 OID 25109)
-- Name: insert_order(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, timestamp without time zone, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_order(IN order_uid character varying, IN track_number character varying, IN entry character varying, IN delivery integer, IN payment character varying, IN locale character varying, IN internal_signature character varying, IN customer_id character varying, IN delivery_service character varying, IN shardkey character varying, IN sm_id integer, IN date_created timestamp without time zone, IN oof_shard character varying)
    LANGUAGE plpgsql
    AS $$
	begin
		INSERT INTO public.orders (order_uid, track_number, entry, delivery, payment, locale, internal_signature, customer_id, delivery_service, shardkey, sm_id, date_created, oof_shard) 
	VALUES(order_uid , track_number , entry , delivery , payment , locale , internal_signature , customer_id , delivery_service, shardkey , sm_id , date_created , oof_shard);

	END;
$$;


--
-- TOC entry 233 (class 1255 OID 25186)
-- Name: insert_order(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, timestamp without time zone, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_order(IN order_uid character varying, IN track_number character varying, IN entry character varying, IN delivery character varying, IN payment character varying, IN locale character varying, IN internal_signature character varying, IN customer_id character varying, IN delivery_service character varying, IN shardkey character varying, IN sm_id integer, IN date_created timestamp without time zone, IN oof_shard character varying)
    LANGUAGE plpgsql
    AS $$
	begin
		INSERT INTO public.orders (order_uid, track_number, entry, delivery, payment, locale, internal_signature, customer_id, delivery_service, shardkey, sm_id, date_created, oof_shard) 
	VALUES(order_uid , track_number , entry , delivery , payment , locale , internal_signature , customer_id , delivery_service, shardkey , sm_id , date_created , oof_shard);

	END;
$$;


--
-- TOC entry 218 (class 1255 OID 25110)
-- Name: insert_order_item(character varying, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_order_item(IN "order" character varying, IN item integer)
    LANGUAGE plpgsql
    AS $$
	begin
		INSERT INTO public.order_items ("order", item) VALUES("order" , item);
	END;
$$;


--
-- TOC entry 231 (class 1255 OID 25106)
-- Name: insert_payment(character varying, character varying, character varying, character varying, integer, integer, character varying, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_payment(IN transaction character varying, IN request_id character varying, IN currency character varying, IN provider character varying, IN amount integer, IN payment_dt integer, IN bank character varying, IN delivery_cost integer, IN goods_total integer, IN custom_fee integer)
    LANGUAGE plpgsql
    AS $$
	begin
		INSERT INTO public.payments ("transaction", request_id, currency, provider, amount, payment_dt, bank, delivery_cost, goods_total, custom_fee) 
		VALUES("transaction", request_id , currency , provider , amount , payment_dt , bank , delivery_cost , goods_total , custom_fee);
	END;
$$;


--
-- TOC entry 232 (class 1255 OID 25102)
-- Name: select_order(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.select_order(uid character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
	begin
	return  json_build_object(
  'order_uid', o.order_uid ,
  'track_number', o.track_number ,
  'entry', o.entry ,
  'delivery', json_build_object(
  	'name', d."name", 
	'phone', d.phone ,
	'zip', d.zip, 
	'city', d.city,
	'address', d.address, 
	'region', d.region, 
	'email', d.email
  ),
  'payment', json_build_object(
    'transaction', p."transaction" ,
    'request_id', p.request_id ,
    'currency', p.currency ,
    'provider', p.provider ,
    'amount', p.amount ,
    'payment_dt', p.payment_dt ,
    'bank', p.bank ,
    'delivery_cost', p.delivery_cost ,
    'goods_total', p.goods_total ,
    'custom_fee', p.custom_fee 
  ),
  'items', json_build_array(json_build_object(
      'chrt_id', i.chrt_id ,
      'track_number', o.track_number ,
      'price', i.price ,
      'rid', i.rid ,
      'name', i."name" ,
      'sale', i.sale,
      'size', i."size" ,
      'total_price', i.total_price ,
      'nm_id', i.nm_id ,
      'brand', i.brand ,
      'status', i.status 
  )),
  'locale', o.locale ,
  'internal_signature', o.internal_signature ,
  'customer_id', o.customer_id ,
  'delivery_service', o.delivery_service ,
  'shardkey', o.shardkey ,
  'sm_id', o.sm_id ,
  'date_created', to_char(o.date_created , 'YYYY-MM-DD"T"HH24:MI:SSZ') ,
  'oof_shard', o.oof_shard 
)
from order_items oi
left join orders o on oi.order = o.order_uid 
left join items i on oi.item = i.chrt_id
left join payments p on o.payment = p."transaction" 
left join deliveries d on o.delivery = d.phone
where o.order_uid = uid;
	END;
$$;


--
-- TOC entry 230 (class 1255 OID 25105)
-- Name: select_orders(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.select_orders(uid character varying DEFAULT ''::character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF uid is null or uid = '' THEN
	    	return json_agg(select_order(oi."order")) from order_items oi;
		ELSE
	    	return * from select_order(uid);
		END IF;
	END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 25028)
-- Name: deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deliveries (
    name character varying,
    phone character varying NOT NULL,
    zip character varying,
    city character varying,
    address character varying,
    region character varying,
    email character varying
);


--
-- TOC entry 210 (class 1259 OID 25034)
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    chrt_id integer NOT NULL,
    price integer,
    rid character varying,
    name character varying,
    sale integer,
    size character varying,
    total_price integer,
    nm_id integer,
    brand character varying,
    status integer
);


--
-- TOC entry 211 (class 1259 OID 25039)
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3350 (class 0 OID 0)
-- Dependencies: 211
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.chrt_id;


--
-- TOC entry 215 (class 1259 OID 25134)
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    "order" character varying,
    item integer
);


--
-- TOC entry 214 (class 1259 OID 25133)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3351 (class 0 OID 0)
-- Dependencies: 214
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 212 (class 1259 OID 25046)
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    order_uid character varying NOT NULL,
    track_number character varying,
    entry character varying,
    delivery character varying,
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


--
-- TOC entry 213 (class 1259 OID 25051)
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
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


--
-- TOC entry 3188 (class 2604 OID 25057)
-- Name: items chrt_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items ALTER COLUMN chrt_id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- TOC entry 3189 (class 2604 OID 25137)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 3191 (class 2606 OID 25170)
-- Name: deliveries deliveries_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pk PRIMARY KEY (phone);


--
-- TOC entry 3193 (class 2606 OID 25062)
-- Name: items items_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pk PRIMARY KEY (chrt_id);


--
-- TOC entry 3201 (class 2606 OID 25141)
-- Name: order_items order_items_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pk PRIMARY KEY (id);


--
-- TOC entry 3195 (class 2606 OID 25068)
-- Name: orders orders_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pk PRIMARY KEY (order_uid);


--
-- TOC entry 3197 (class 2606 OID 25070)
-- Name: orders orders_un; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_un UNIQUE (track_number);


--
-- TOC entry 3199 (class 2606 OID 25064)
-- Name: payments payments_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pk PRIMARY KEY (transaction);


--
-- TOC entry 3204 (class 2606 OID 25142)
-- Name: order_items order_items_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_fk FOREIGN KEY ("order") REFERENCES public.orders(order_uid);


--
-- TOC entry 3205 (class 2606 OID 25147)
-- Name: order_items order_items_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_fk_1 FOREIGN KEY (item) REFERENCES public.items(chrt_id);


--
-- TOC entry 3202 (class 2606 OID 25121)
-- Name: orders orders_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_fk FOREIGN KEY (payment) REFERENCES public.payments(transaction);


--
-- TOC entry 3203 (class 2606 OID 25181)
-- Name: orders orders_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_fk_1 FOREIGN KEY (delivery) REFERENCES public.deliveries(phone);


-- Completed on 2022-10-03 09:47:13

--
-- PostgreSQL database dump complete
--

