--
-- PostgreSQL database dump
--

\restrict fRtnQDTUEktKpaOzdCL9nnNZGLxC1pbKxcOcr0xF20GSs4qST7uC7KH6V9PoVKJ

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-11-20 02:18:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16431)
-- Name: preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.preference (
    preference_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    occupation_code character(3) NOT NULL,
    stand_name character varying(10) NOT NULL,
    reservation_time timestamp without time zone NOT NULL,
    CONSTRAINT preference_occupation_code_check CHECK ((occupation_code = ANY (ARRAY['STU'::bpchar, 'EDU'::bpchar, 'MLT'::bpchar, 'OTH'::bpchar])))
);


ALTER TABLE public.preference OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16430)
-- Name: preference_preference_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.preference_preference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.preference_preference_id_seq OWNER TO postgres;

--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 219
-- Name: preference_preference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.preference_preference_id_seq OWNED BY public.preference.preference_id;


--
-- TOC entry 222 (class 1259 OID 16463)
-- Name: reward; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reward (
    id bigint NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    email character varying(255),
    phone character varying(50),
    preferred_stand character varying(10),
    seat integer
);


ALTER TABLE public.reward OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16462)
-- Name: reward_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reward_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reward_id_seq OWNER TO postgres;

--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 221
-- Name: reward_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reward_id_seq OWNED BY public.reward.id;


--
-- TOC entry 218 (class 1259 OID 16417)
-- Name: stand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stand (
    stand_id integer NOT NULL,
    name character varying(10) NOT NULL,
    available_seats integer NOT NULL,
    discount_price numeric(10,2) NOT NULL,
    reserved_seats text[] NOT NULL,
    CONSTRAINT stand_available_seats_check CHECK ((available_seats > 0)),
    CONSTRAINT stand_discount_price_check CHECK ((discount_price >= (0)::numeric)),
    CONSTRAINT stand_name_check CHECK (((name)::text = ANY ((ARRAY['EAST'::character varying, 'WEST'::character varying, 'SOUTH'::character varying, 'NORTH'::character varying])::text[])))
);


ALTER TABLE public.stand OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16416)
-- Name: stand_stand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stand_stand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stand_stand_id_seq OWNER TO postgres;

--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 217
-- Name: stand_stand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stand_stand_id_seq OWNED BY public.stand.stand_id;


--
-- TOC entry 4652 (class 2604 OID 16434)
-- Name: preference preference_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference ALTER COLUMN preference_id SET DEFAULT nextval('public.preference_preference_id_seq'::regclass);


--
-- TOC entry 4653 (class 2604 OID 16466)
-- Name: reward id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward ALTER COLUMN id SET DEFAULT nextval('public.reward_id_seq'::regclass);


--
-- TOC entry 4651 (class 2604 OID 16420)
-- Name: stand stand_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stand ALTER COLUMN stand_id SET DEFAULT nextval('public.stand_stand_id_seq'::regclass);


--
-- TOC entry 4819 (class 0 OID 16431)
-- Dependencies: 220
-- Data for Name: preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.preference (preference_id, first_name, last_name, email, phone, occupation_code, stand_name, reservation_time) FROM stdin;
70	Victor	Adams	victor@example.com	555-0501	MLT	EAST	2025-11-07 07:55:00
71	Wendy	Baker	wendy@example.com	555-0502	STU	EAST	2025-11-07 07:58:00
72	Xavier	Clark	xavier@example.com	555-0503	EDU	EAST	2025-11-07 07:59:00
73	Yara	Davis	yara@example.com	555-0601	MLT	WEST	2025-11-07 08:50:00
74	Zane	Evans	zane@example.com	555-0602	OTH	WEST	2025-11-07 08:52:00
75	Aaron	Ford	aaron@example.com	555-0603	STU	WEST	2025-11-07 08:53:00
76	Bella	Green	bella@example.com	555-0701	MLT	SOUTH	2025-11-07 09:30:00
77	Caleb	Hill	caleb@example.com	555-0702	EDU	SOUTH	2025-11-07 09:31:00
78	Daisy	Ivy	daisy@example.com	555-0703	OTH	SOUTH	2025-11-07 09:32:00
79	Evan	Jones	evan@example.com	555-0704	STU	SOUTH	2025-11-07 09:33:00
80	Felix	King	felix@example.com	555-0801	MLT	NORTH	2025-11-07 10:15:00
81	Gina	Lewis	gina@example.com	555-0802	MLT	NORTH	2025-11-07 10:16:00
82	Hank	Mason	hank@example.com	555-0803	EDU	NORTH	2025-11-07 10:17:00
83	Iris	Nash	iris@example.com	555-0804	OTH	NORTH	2025-11-07 10:18:00
\.


--
-- TOC entry 4821 (class 0 OID 16463)
-- Dependencies: 222
-- Data for Name: reward; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reward (id, first_name, last_name, email, phone, preferred_stand, seat) FROM stdin;
267	Victor	Adams	victor@example.com	555-0501	EAST	1
268	Wendy	Baker	wendy@example.com	555-0502	EAST	2
269	Xavier	Clark	xavier@example.com	555-0503	EAST	3
270	Yara	Davis	yara@example.com	555-0601	WEST	1
271	Zane	Evans	zane@example.com	555-0602	WEST	2
272	Aaron	Ford	aaron@example.com	555-0603	WEST	3
273	Caleb	Hill	caleb@example.com	555-0702	SOUTH	1
274	Bella	Green	bella@example.com	555-0701	SOUTH	2
275	Evan	Jones	evan@example.com	555-0704	SOUTH	3
276	Daisy	Ivy	daisy@example.com	555-0703	SOUTH	4
277	Felix	King	felix@example.com	555-0801	NORTH	1
278	Gina	Lewis	gina@example.com	555-0802	NORTH	2
279	Hank	Mason	hank@example.com	555-0803	NORTH	3
\.


--
-- TOC entry 4817 (class 0 OID 16417)
-- Dependencies: 218
-- Data for Name: stand; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stand (stand_id, name, available_seats, discount_price, reserved_seats) FROM stdin;
1	EAST	3	10.00	{E001,E002,E003}
2	WEST	3	5.00	{W501,W502,W503}
3	SOUTH	5	2.00	{S101,S102,S103,S104,S105}
4	NORTH	5	2.00	{N601,N602,N603,N604,N605}
\.


--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 219
-- Name: preference_preference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.preference_preference_id_seq', 83, true);


--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 221
-- Name: reward_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reward_id_seq', 279, true);


--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 217
-- Name: stand_stand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stand_stand_id_seq', 4, true);


--
-- TOC entry 4666 (class 2606 OID 16437)
-- Name: preference preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference
    ADD CONSTRAINT preference_pkey PRIMARY KEY (preference_id);


--
-- TOC entry 4669 (class 2606 OID 16470)
-- Name: reward reward_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward
    ADD CONSTRAINT reward_pkey PRIMARY KEY (id);


--
-- TOC entry 4659 (class 2606 OID 16429)
-- Name: stand stand_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stand
    ADD CONSTRAINT stand_name_key UNIQUE (name);


--
-- TOC entry 4661 (class 2606 OID 16427)
-- Name: stand stand_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stand
    ADD CONSTRAINT stand_pkey PRIMARY KEY (stand_id);


--
-- TOC entry 4662 (class 1259 OID 16461)
-- Name: idx_preference_name_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_preference_name_lower ON public.preference USING btree (lower((first_name)::text), lower((last_name)::text));


--
-- TOC entry 4663 (class 1259 OID 16459)
-- Name: idx_preference_stand; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_preference_stand ON public.preference USING btree (stand_name);


--
-- TOC entry 4664 (class 1259 OID 16460)
-- Name: idx_preference_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_preference_time ON public.preference USING btree (reservation_time);


--
-- TOC entry 4667 (class 1259 OID 16471)
-- Name: idx_reward_stand; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reward_stand ON public.reward USING btree (preferred_stand);


--
-- TOC entry 4670 (class 2606 OID 16438)
-- Name: preference preference_stand_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preference
    ADD CONSTRAINT preference_stand_name_fkey FOREIGN KEY (stand_name) REFERENCES public.stand(name) ON DELETE RESTRICT;


-- Completed on 2025-11-20 02:18:29

--
-- PostgreSQL database dump complete
--

\unrestrict fRtnQDTUEktKpaOzdCL9nnNZGLxC1pbKxcOcr0xF20GSs4qST7uC7KH6V9PoVKJ

