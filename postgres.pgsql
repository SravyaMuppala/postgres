--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Debian 12.3-1.pgdg100+1)
-- Dumped by pg_dump version 12.3 (Debian 12.3-1.pgdg100+1)

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
-- Name: run_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.run_status AS ENUM (
    'unstarted',
    'in_progress',
    'pending_incoming_confirmations',
    'pending_outgoing_confirmations',
    'pending_connection',
    'pending_bridge',
    'pending_sleep',
    'errored',
    'completed',
    'cancelled'
);


ALTER TYPE public.run_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bridge_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bridge_types (
    name text NOT NULL,
    url text NOT NULL,
    confirmations bigint DEFAULT 0 NOT NULL,
    incoming_token_hash text NOT NULL,
    salt text NOT NULL,
    outgoing_token text NOT NULL,
    minimum_contract_payment character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.bridge_types OWNER TO postgres;

--
-- Name: configurations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configurations (
    id bigint NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.configurations OWNER TO postgres;

--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.configurations_id_seq OWNER TO postgres;

--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: encrypted_secret_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encrypted_secret_keys (
    public_key character varying(68) NOT NULL,
    vrf_key text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.encrypted_secret_keys OWNER TO postgres;

--
-- Name: encumbrances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encumbrances (
    id bigint NOT NULL,
    payment numeric(78,0),
    expiration bigint,
    end_at timestamp with time zone,
    oracles text,
    aggregator bytea NOT NULL,
    agg_initiate_job_selector bytea NOT NULL,
    agg_fulfill_selector bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.encumbrances OWNER TO postgres;

--
-- Name: encumbrances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.encumbrances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.encumbrances_id_seq OWNER TO postgres;

--
-- Name: encumbrances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.encumbrances_id_seq OWNED BY public.encumbrances.id;


--
-- Name: external_initiators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.external_initiators (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    url text,
    access_key text NOT NULL,
    salt text NOT NULL,
    hashed_secret text NOT NULL,
    outgoing_secret text NOT NULL,
    outgoing_token text NOT NULL
);


ALTER TABLE public.external_initiators OWNER TO postgres;

--
-- Name: external_initiators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.external_initiators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.external_initiators_id_seq OWNER TO postgres;

--
-- Name: external_initiators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.external_initiators_id_seq OWNED BY public.external_initiators.id;


--
-- Name: heads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.heads (
    id bigint NOT NULL,
    hash bytea NOT NULL,
    number bigint NOT NULL,
    parent_hash bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    CONSTRAINT chk_hash_size CHECK ((octet_length(hash) = 32)),
    CONSTRAINT chk_parent_hash_size CHECK ((octet_length(parent_hash) = 32))
);


ALTER TABLE public.heads OWNER TO postgres;

--
-- Name: heads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.heads_id_seq OWNER TO postgres;

--
-- Name: heads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.heads_id_seq OWNED BY public.heads.id;


--
-- Name: initiators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.initiators (
    id bigint NOT NULL,
    job_spec_id uuid NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    schedule text,
    "time" timestamp with time zone,
    ran boolean,
    address bytea,
    requesters text,
    name character varying(255),
    params jsonb,
    from_block numeric(78,0),
    to_block numeric(78,0),
    topics jsonb,
    request_data text,
    feeds text,
    threshold double precision,
    "precision" smallint,
    polling_interval bigint,
    absolute_threshold double precision,
    updated_at timestamp with time zone NOT NULL,
    poll_timer jsonb,
    idle_timer jsonb
);


ALTER TABLE public.initiators OWNER TO postgres;

--
-- Name: initiators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.initiators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.initiators_id_seq OWNER TO postgres;

--
-- Name: initiators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.initiators_id_seq OWNED BY public.initiators.id;


--
-- Name: job_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_runs (
    result_id bigint,
    run_request_id bigint,
    status public.run_status DEFAULT 'unstarted'::public.run_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    finished_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL,
    initiator_id bigint NOT NULL,
    deleted_at timestamp with time zone,
    creation_height numeric(78,0),
    observed_height numeric(78,0),
    payment numeric(78,0),
    job_spec_id uuid NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE public.job_runs OWNER TO postgres;

--
-- Name: job_specs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_specs (
    created_at timestamp with time zone NOT NULL,
    start_at timestamp with time zone,
    end_at timestamp with time zone,
    deleted_at timestamp with time zone,
    min_payment character varying(255),
    id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.job_specs OWNER TO postgres;

--
-- Name: keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keys (
    address bytea NOT NULL,
    json jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.keys OWNER TO postgres;

--
-- Name: log_consumptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_consumptions (
    id bigint NOT NULL,
    block_hash bytea NOT NULL,
    log_index bigint NOT NULL,
    job_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.log_consumptions OWNER TO postgres;

--
-- Name: log_consumptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_consumptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_consumptions_id_seq OWNER TO postgres;

--
-- Name: log_consumptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_consumptions_id_seq OWNED BY public.log_consumptions.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id character varying(255) NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: run_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.run_requests (
    id bigint NOT NULL,
    request_id bytea,
    tx_hash bytea,
    requester bytea,
    created_at timestamp with time zone NOT NULL,
    block_hash bytea,
    payment numeric(78,0),
    request_params jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.run_requests OWNER TO postgres;

--
-- Name: run_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.run_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.run_requests_id_seq OWNER TO postgres;

--
-- Name: run_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.run_requests_id_seq OWNED BY public.run_requests.id;


--
-- Name: run_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.run_results (
    id bigint NOT NULL,
    data jsonb,
    error_message text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.run_results OWNER TO postgres;

--
-- Name: run_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.run_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.run_results_id_seq OWNER TO postgres;

--
-- Name: run_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.run_results_id_seq OWNED BY public.run_results.id;


--
-- Name: service_agreements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_agreements (
    id text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    encumbrance_id bigint,
    request_body text,
    signature character varying(255),
    job_spec_id uuid,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.service_agreements OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id text NOT NULL,
    last_used timestamp with time zone,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: sync_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sync_events (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    body text NOT NULL
);


ALTER TABLE public.sync_events OWNER TO postgres;

--
-- Name: sync_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sync_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sync_events_id_seq OWNER TO postgres;

--
-- Name: sync_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sync_events_id_seq OWNED BY public.sync_events.id;


--
-- Name: task_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_runs (
    result_id bigint,
    status public.run_status DEFAULT 'unstarted'::public.run_status NOT NULL,
    task_spec_id bigint NOT NULL,
    minimum_confirmations bigint,
    created_at timestamp with time zone NOT NULL,
    confirmations bigint,
    job_run_id uuid NOT NULL,
    id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.task_runs OWNER TO postgres;

--
-- Name: task_specs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_specs (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    type text NOT NULL,
    confirmations bigint,
    params jsonb,
    job_spec_id uuid NOT NULL
);


ALTER TABLE public.task_specs OWNER TO postgres;

--
-- Name: task_specs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_specs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_specs_id_seq OWNER TO postgres;

--
-- Name: task_specs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_specs_id_seq OWNED BY public.task_specs.id;


--
-- Name: tx_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tx_attempts (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    hash bytea NOT NULL,
    gas_price numeric(78,0) NOT NULL,
    confirmed boolean NOT NULL,
    sent_at bigint NOT NULL,
    signed_raw_tx bytea NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.tx_attempts OWNER TO postgres;

--
-- Name: tx_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tx_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tx_attempts_id_seq OWNER TO postgres;

--
-- Name: tx_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tx_attempts_id_seq OWNED BY public.tx_attempts.id;


--
-- Name: txes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.txes (
    id bigint NOT NULL,
    surrogate_id text,
    "from" bytea NOT NULL,
    "to" bytea NOT NULL,
    data bytea NOT NULL,
    nonce bigint NOT NULL,
    value numeric(78,0) NOT NULL,
    gas_limit bigint NOT NULL,
    hash bytea NOT NULL,
    gas_price numeric(78,0) NOT NULL,
    confirmed boolean NOT NULL,
    sent_at bigint NOT NULL,
    signed_raw_tx bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.txes OWNER TO postgres;

--
-- Name: txes_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.txes_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.txes_id_seq1 OWNER TO postgres;

--
-- Name: txes_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.txes_id_seq1 OWNED BY public.txes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    email text NOT NULL,
    hashed_password text,
    created_at timestamp with time zone NOT NULL,
    token_key text,
    token_salt text,
    token_hashed_secret text,
    updated_at timestamp with time zone NOT NULL,
    token_secret text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: encumbrances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encumbrances ALTER COLUMN id SET DEFAULT nextval('public.encumbrances_id_seq'::regclass);


--
-- Name: external_initiators id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_initiators ALTER COLUMN id SET DEFAULT nextval('public.external_initiators_id_seq'::regclass);


--
-- Name: heads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.heads ALTER COLUMN id SET DEFAULT nextval('public.heads_id_seq'::regclass);


--
-- Name: initiators id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initiators ALTER COLUMN id SET DEFAULT nextval('public.initiators_id_seq'::regclass);


--
-- Name: log_consumptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_consumptions ALTER COLUMN id SET DEFAULT nextval('public.log_consumptions_id_seq'::regclass);


--
-- Name: run_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_requests ALTER COLUMN id SET DEFAULT nextval('public.run_requests_id_seq'::regclass);


--
-- Name: run_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_results ALTER COLUMN id SET DEFAULT nextval('public.run_results_id_seq'::regclass);


--
-- Name: sync_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sync_events ALTER COLUMN id SET DEFAULT nextval('public.sync_events_id_seq'::regclass);


--
-- Name: task_specs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_specs ALTER COLUMN id SET DEFAULT nextval('public.task_specs_id_seq'::regclass);


--
-- Name: tx_attempts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tx_attempts ALTER COLUMN id SET DEFAULT nextval('public.tx_attempts_id_seq'::regclass);


--
-- Name: txes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.txes ALTER COLUMN id SET DEFAULT nextval('public.txes_id_seq1'::regclass);


--
-- Data for Name: bridge_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bridge_types (name, url, confirmations, incoming_token_hash, salt, outgoing_token, minimum_contract_payment, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: configurations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configurations (id, name, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: encrypted_secret_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encrypted_secret_keys (public_key, vrf_key, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: encumbrances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encumbrances (id, payment, expiration, end_at, oracles, aggregator, agg_initiate_job_selector, agg_fulfill_selector, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: external_initiators; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.external_initiators (id, created_at, updated_at, deleted_at, name, url, access_key, salt, hashed_secret, outgoing_secret, outgoing_token) FROM stdin;
\.


--
-- Data for Name: heads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.heads (id, hash, number, parent_hash, created_at, "timestamp") FROM stdin;
1280	\\xf6c95beca0c6e0f9feb2938cd12837b4d12f266704d5df037186092692ddb0cb	8058099	\\x3ecf79aaad45e749b2898868003f7b6a9862509d2e42e252484d09b143bd8912	2020-06-09 18:10:29.771982+00	2020-06-09 18:09:54+00
1282	\\xef35453b9f67e7f406633ccd8d9fecbede336f1148f3f18b234fee09d306133d	8058101	\\xfbe4ce5e4dc72e81954e21e4446f070998c946d323c16389b47c8bafa88e1767	2020-06-09 18:10:43.094251+00	2020-06-09 18:10:29+00
1284	\\xc7d0a257d3041396d216ab9fd1dc687bec5e8a3326df409aaa9be96bb60834f5	8058103	\\x125bb5a24678f289c87f05d1f7ebcfa819271db6129b0d67f4d3ce96d0b81dfb	2020-06-09 18:11:08.905428+00	2020-06-09 18:11:00+00
1286	\\x47c738f01fcdba388104c0db5a29ff34c6cef172ec8fbdeb42134b01409a2e8a	8058105	\\x12fde6d856dd5411b3f39c43916656129544c60d43b3f6e78208c6f0a9039698	2020-06-09 18:11:28.605206+00	2020-06-09 18:11:27+00
1288	\\x8a06b88eec741e723c98aa76f156771142524fc7b7e60286199a0f6137f5e5e0	8058107	\\xd00e3fec1a5c79c095bff44c8d3abe608c447882186e1f5342816d8fcf6d34a0	2020-06-09 18:11:51.005431+00	2020-06-09 18:11:45+00
1290	\\xe3053a422294c48015f074ef882820077e95db8b7a3f1cddbd089a2064a9d0b1	8058109	\\x4187dc980d1a8ee6ebb4ad117d7e872f2028de285560f068ea29fb442b545e41	2020-06-09 18:12:30.202914+00	2020-06-09 18:12:07+00
1292	\\x9f803ee10d14cc65a0c62a9034a4dfad8fbb1697fcc706c4bdedba9c3b253064	8058111	\\x62b2f9619bdf5f1a40a7384dc5b67567e275f2665549f8faa65a96c7f0a7f3b8	2020-06-09 18:13:21.434322+00	2020-06-09 18:13:03+00
1294	\\x73c9920dda13fe614b8dbdbfcc7780f9ef92a50e5ee50d67ec0252ce4fe95dd9	8058113	\\x4a308cc9e2d1eef78dd1bffe6e1f2e038247067157e27b36f214159fd39a8c8f	2020-06-09 18:13:37.650513+00	2020-06-09 18:13:31+00
1296	\\xcf7ce2ac95330321920b870bb7427b4c19a0949b6facb7770bca7b9c973101bf	8058115	\\x8a1c85f18df654fb85c2406e94f312aaf5cdc00e3604cf05462275222bdbb6a2	2020-06-09 18:13:46.490689+00	2020-06-09 18:13:36+00
1299	\\xce5bd8e1d25fb86f4e56142a9dd81a47e6a95766c413630e54688613fe09817c	8058117	\\x1b568dbfd842ef87f5637f3eaadf1b1ac626264324bb5a60c7cbe0560ec3dd4a	2020-06-09 18:14:20.797931+00	2020-06-09 18:14:13+00
1267	\\x43e648d04e0916d41cb814b28a1cc73b4b3cdadc623866d6ac3013c8fd1be386	8058086	\\x7a0bd784e355bfc5e510afe7b49119249d3d5a4e1004067c6eaf8e5edb9ca9f6	2020-06-09 18:08:06.393394+00	2020-06-09 18:07:59+00
1269	\\xacc4e64cb490ad6efb0244723b1135e6f8cdaaf4cc3c7d565746511071aaa7ab	8058088	\\x8ce2133af026623c941d5a95dbb119bc613439ab355d0d59b5ff008da27a4f8f	2020-06-09 18:08:42.029233+00	2020-06-09 18:08:08+00
1271	\\x290873da3b18e1dd12dbfbca5ee522546cbc845f55e40badce118d49d63a8ebf	8058090	\\x0026198392b5cad03395c9a45b40e263beeafbefb4256e3ac11f1696df1db033	2020-06-09 18:08:59.389454+00	2020-06-09 18:08:50+00
1273	\\x1177053bc6812be55d540de51cce4097b9d826ecab32e2f8c1038ee0c3a83924	8058092	\\xcf854ec4887517a08ca15f9a6359bb28ead2f9d623fe5fc3e164aa0849a92eaf	2020-06-09 18:09:05.76758+00	2020-06-09 18:08:59+00
1275	\\xa82dcaf88145115844269a5e934f101ce551bd91111828b8b32b5fbd443f1fac	8058094	\\xe4be83ac57a94b806d8d1ee40da73733fd0ac1ae47ccd0c6d96deffd4d790655	2020-06-09 18:09:26.629959+00	2020-06-09 18:09:11+00
1277	\\x5f77f789c0d7438a0d2bcc3ac382799be3f5c3d7950ecf4db604634d941705e5	8058096	\\x8d5d119f18f3aa3cf34dfbca71f23806eddf94667c3797c2c441fe0133f12735	2020-06-09 18:09:39.415907+00	2020-06-09 18:09:38+00
1279	\\x3ecf79aaad45e749b2898868003f7b6a9862509d2e42e252484d09b143bd8912	8058098	\\x8ef52aded341bf29fd3ae5084fbab610307a27067a06cf4866f90fafd72e7055	2020-06-09 18:09:53.915372+00	2020-06-09 18:09:43+00
1268	\\x8ce2133af026623c941d5a95dbb119bc613439ab355d0d59b5ff008da27a4f8f	8058087	\\x43e648d04e0916d41cb814b28a1cc73b4b3cdadc623866d6ac3013c8fd1be386	2020-06-09 18:08:42.024937+00	2020-06-09 18:08:06+00
1281	\\xfbe4ce5e4dc72e81954e21e4446f070998c946d323c16389b47c8bafa88e1767	8058100	\\xf6c95beca0c6e0f9feb2938cd12837b4d12f266704d5df037186092692ddb0cb	2020-06-09 18:10:29.775787+00	2020-06-09 18:09:56+00
1283	\\x125bb5a24678f289c87f05d1f7ebcfa819271db6129b0d67f4d3ce96d0b81dfb	8058102	\\xef35453b9f67e7f406633ccd8d9fecbede336f1148f3f18b234fee09d306133d	2020-06-09 18:11:00.524959+00	2020-06-09 18:10:41+00
1285	\\x12fde6d856dd5411b3f39c43916656129544c60d43b3f6e78208c6f0a9039698	8058104	\\xc7d0a257d3041396d216ab9fd1dc687bec5e8a3326df409aaa9be96bb60834f5	2020-06-09 18:11:27.657663+00	2020-06-09 18:11:08+00
1287	\\xd00e3fec1a5c79c095bff44c8d3abe608c447882186e1f5342816d8fcf6d34a0	8058106	\\x47c738f01fcdba388104c0db5a29ff34c6cef172ec8fbdeb42134b01409a2e8a	2020-06-09 18:11:45.526819+00	2020-06-09 18:11:28+00
1289	\\x4187dc980d1a8ee6ebb4ad117d7e872f2028de285560f068ea29fb442b545e41	8058108	\\x8a06b88eec741e723c98aa76f156771142524fc7b7e60286199a0f6137f5e5e0	2020-06-09 18:12:07.682985+00	2020-06-09 18:11:51+00
1291	\\x62b2f9619bdf5f1a40a7384dc5b67567e275f2665549f8faa65a96c7f0a7f3b8	8058110	\\xe3053a422294c48015f074ef882820077e95db8b7a3f1cddbd089a2064a9d0b1	2020-06-09 18:13:03.34199+00	2020-06-09 18:12:30+00
1293	\\x4a308cc9e2d1eef78dd1bffe6e1f2e038247067157e27b36f214159fd39a8c8f	8058112	\\x9f803ee10d14cc65a0c62a9034a4dfad8fbb1697fcc706c4bdedba9c3b253064	2020-06-09 18:13:31.785999+00	2020-06-09 18:13:21+00
1295	\\x8a1c85f18df654fb85c2406e94f312aaf5cdc00e3604cf05462275222bdbb6a2	8058114	\\x73c9920dda13fe614b8dbdbfcc7780f9ef92a50e5ee50d67ec0252ce4fe95dd9	2020-06-09 18:13:37.656229+00	2020-06-09 18:13:32+00
1297	\\xd078564fa996eea4888988d9d9039750e97caee3b44c7d5da811045a6ee8ecf6	8058115	\\x8a1c85f18df654fb85c2406e94f312aaf5cdc00e3604cf05462275222bdbb6a2	2020-06-09 18:14:13.068656+00	2020-06-09 18:13:36+00
1298	\\x1b568dbfd842ef87f5637f3eaadf1b1ac626264324bb5a60c7cbe0560ec3dd4a	8058116	\\xd078564fa996eea4888988d9d9039750e97caee3b44c7d5da811045a6ee8ecf6	2020-06-09 18:14:13.071524+00	2020-06-09 18:13:46+00
1300	\\x0c1d1570e547f8132c85b23c13e08131f3bdeefca746a4e63320875a5b992b47	8058118	\\xce5bd8e1d25fb86f4e56142a9dd81a47e6a95766c413630e54688613fe09817c	2020-06-09 18:14:30.809381+00	2020-06-09 18:14:20+00
1270	\\x0026198392b5cad03395c9a45b40e263beeafbefb4256e3ac11f1696df1db033	8058089	\\xacc4e64cb490ad6efb0244723b1135e6f8cdaaf4cc3c7d565746511071aaa7ab	2020-06-09 18:08:50.767206+00	2020-06-09 18:08:42+00
1272	\\xcf854ec4887517a08ca15f9a6359bb28ead2f9d623fe5fc3e164aa0849a92eaf	8058091	\\x290873da3b18e1dd12dbfbca5ee522546cbc845f55e40badce118d49d63a8ebf	2020-06-09 18:08:59.393437+00	2020-06-09 18:08:55+00
1274	\\xe4be83ac57a94b806d8d1ee40da73733fd0ac1ae47ccd0c6d96deffd4d790655	8058093	\\x1177053bc6812be55d540de51cce4097b9d826ecab32e2f8c1038ee0c3a83924	2020-06-09 18:09:11.921205+00	2020-06-09 18:09:05+00
1276	\\x8d5d119f18f3aa3cf34dfbca71f23806eddf94667c3797c2c441fe0133f12735	8058095	\\xa82dcaf88145115844269a5e934f101ce551bd91111828b8b32b5fbd443f1fac	2020-06-09 18:09:38.928847+00	2020-06-09 18:09:26+00
1278	\\x8ef52aded341bf29fd3ae5084fbab610307a27067a06cf4866f90fafd72e7055	8058097	\\x5f77f789c0d7438a0d2bcc3ac382799be3f5c3d7950ecf4db604634d941705e5	2020-06-09 18:09:53.89737+00	2020-06-09 18:09:39+00
1301	\\x78fa603faca96770258f7995198eb360ca68a8ab0f690a15782d8ab2bbbb3f7a	8058119	\\x0c1d1570e547f8132c85b23c13e08131f3bdeefca746a4e63320875a5b992b47	2020-06-09 18:15:35.332637+00	2020-06-09 18:14:30+00
1304	\\x71c7d700b9bc2ce30baa72efeca40302a95021bf0ffc48cf7b9da518c89d07b6	8058121	\\xd97a9011f9c096c8dfe35adabfefbb61df85b7cb397538ca000fe4634c1096d3	2020-06-09 18:16:15.277886+00	2020-06-09 18:15:54+00
1306	\\x8e16b1a351cd98ac1c5ac69b03e63996cf6a683c30a6aae2860ed2d63c0f2122	8058123	\\x0312381acacef36a13969c104fbbb4bb92346f728f67a6be7007b36c9b758adf	2020-06-09 18:17:04.96295+00	2020-06-09 18:16:26+00
1308	\\x47139cc1b6302b92a4e545f257d7d60316c4c8f42a8f28781a34c122b1eac6c6	8058125	\\x943be1d045f8653635d03a3daccb29f27000a06eac87671d119335e581e36e0c	2020-06-09 18:17:24.698211+00	2020-06-09 18:17:08+00
1310	\\xaecb3d7b7aaaf4807545cd1dbd10f6234e1e59741024e52e04c14c2d36548239	8058127	\\xe5730547d136f4d0862e82b18a6f870f7abcb086e8ee4c2fc0e3e12ad87fb313	2020-06-09 18:18:50.921623+00	2020-06-09 18:18:44+00
1312	\\x0941755262d4067ed4b9691c1f62c03e123df661379bb57f1289aed62e8788a2	8058129	\\x2008cff4e78cd29b3337da70190ae33a3de465508903e6e5b512b95982067229	2020-06-09 18:19:12.066104+00	2020-06-09 18:18:59+00
1247	\\xfd20ba75c5bcb514536bd6edff5e904b3b997bc681489373bd16864412028101	8058066	\\x875afb955f2ffe6ab60ae8b7b46d8f48b79f8963bb5d8ffecdfb70d4aa9cbdb2	2020-06-09 18:01:23.10442+00	2020-06-09 18:01:12+00
1249	\\x9e1e05b3fb091109b8b518f8589087387305892e5862e0ce769dcb8af4047862	8058068	\\x06b38b870c7dd3c2f8679340cef96114efbda0002232ad6f378a27822d2ca3e4	2020-06-09 18:01:59.477267+00	2020-06-09 18:01:31+00
1314	\\x54ff07b98d1e693689c8731d73e54ef067671e3fefb3111ba0df45de28dd2817	8058131	\\xa12394e7b6ddb276a6d696c670d27bc5aeb4c2709efc81ab9ad981e84bb1501b	2020-06-09 18:19:31.201811+00	2020-06-09 18:19:19+00
1316	\\x4f8d28e57a945bbe9abdc58bed2798658e5c7a44e892a5520c6b2977487d7e9b	8058133	\\xa09ba23dd4c7382ccf5d32101e782b259f5a5f9c760cdd366fc832327a586aee	2020-06-09 18:19:56.235101+00	2020-06-09 18:19:48+00
1318	\\xb6082e369bae9c54a5bca6c3f36cad6060f61bad38492ca14e6d572faf9f5e1f	8058135	\\xc053b05e870440e92af1f03464166f526c54877b3f8500d552899d0b3b6d0ed2	2020-06-09 18:20:21.992835+00	2020-06-09 18:20:06+00
1320	\\xaf285ea238600fa66efeda5c943f8e34e622990659bfa78adf162257838238d0	8058137	\\x2cb2ef883e495510846a313e7fcb3254692d580f13dc6df338b8c1c7ce05fcd9	2020-06-09 18:20:28.846798+00	2020-06-09 18:20:23+00
1322	\\xbdd09b85fdb385fbbd4c5fc5c177d142159a4a578e98110211b0c32748a430b3	8058139	\\x852deb65b356a18fc8082d71c0c63f857856a95a51c858f1c90fe93d87e7e109	2020-06-09 18:21:02.115505+00	2020-06-09 18:20:59+00
1324	\\x4024696e54d88472a89b3df7de2ddf1e23fb9f804cb687082b4e507de871f50c	8058141	\\x2b4ce1fdf16bce74a031945f25d608dad7fb121eb252257ff4dae0f6fc7c6a19	2020-06-09 18:22:00.402868+00	2020-06-09 18:21:26+00
1326	\\xdcb537858d62ec56ceebe309951e31b9a60e557440671e7379c2a2d9d2ee1924	8058143	\\x3677323c1ea963412acf29ad06ef8a66d478f92c36bd42f8bb015aee5a10f480	2020-06-09 18:22:38.23045+00	2020-06-09 18:22:08+00
1328	\\xbf9f0f52615a7c232615c5852f44eca12259f4912b5a514fc636eab39954a6d9	8058145	\\x346e781fa53cbb3b214130519929b7efe8357bcc2631fa36dcee49cea997960d	2020-06-09 18:22:56.567668+00	2020-06-09 18:22:44+00
1330	\\x1ab4f3ecce8ba480465340a9bd19423d5246054963cdfc45bd7d3bd127d2d259	8058147	\\xf1fc9aee8feba083aed30064c72942f2a06d3cd83af1a77567e800b85dde1923	2020-06-09 18:23:04.352803+00	2020-06-09 18:22:56+00
1332	\\xd92389e94bf4bb15628aa2c51271fce257f3cf83698826b4a6f506cebeec91e2	8058149	\\x620c9ca12cf57b87c420a6c8adb798f248937f719908c4787420cc467c3b21b3	2020-06-09 18:23:11.829515+00	2020-06-09 18:23:07+00
1334	\\x7cd85c61457299b0b67c189c7ffa1b33578b5c3db47dd8730105f8011bdcf87e	8058151	\\xa04c95130c3bc3b75d74b2f1bfa525b8816fd709e8c0de1dafc8d52db3f1a3d3	2020-06-09 18:23:38.743121+00	2020-06-09 18:23:24+00
1337	\\xe45c933a031d5163a1a08e6d403995cee888fb1ee2f7c4503a47e2dd5b7d5d08	8058154	\\xe3847073f54b6ab5794c6f0d1d6e87a1db68568fddf8c5ab09847abe31b16a85	2020-06-09 18:24:19.409841+00	2020-06-09 18:24:09+00
1339	\\xdf82dfeacffbc156479beb5755aebd9e258701e74d1e52d9f2450765d1491dfe	8058156	\\x1d8e13986ada00abd055f539089a114b47f3e11ab1954f634efd9d9ee7b65458	2020-06-09 18:25:01.643396+00	2020-06-09 18:24:56+00
1341	\\x5c22b2a0711ec90ca13ca7ec8d42a1343fdac70e543d11180dacd74563c236d1	8058158	\\x37deff0770d1870887d6d6db642e05b2129332764c4e9ca890ee38996daabdb1	2020-06-09 18:25:44.188535+00	2020-06-09 18:25:36+00
1343	\\xbed2f02661e114068f4c87b4ecc4bdcdcbcabca3d3c089cf11a0109d5099a9b0	8058160	\\xa29b9d1f4b5d3177f747ec91efe5bb4bf774b589f61f880bf75868f0a8db6226	2020-06-09 18:26:18.858566+00	2020-06-09 18:25:51+00
1345	\\xc6e59753940defe5a1753e76fea8dd5fbad80b37160752f1fa469742e35cb320	8058162	\\xb47515dcdbf837c7b016430520a85d67c8f86a38c23a83f02fbd7e614b724661	2020-06-09 18:26:26.227619+00	2020-06-09 18:26:18+00
1251	\\x6a32d2b47ae5d30d7e2b2e255968af13bdfb8c0b2b0ea35d15d1bdc072d50fdb	8058070	\\x87c684247f2ac635341187f1bef48a279584ccf28274abf0260ab6e2a0c1701a	2020-06-09 18:02:05.353426+00	2020-06-09 18:02:01+00
1253	\\xae0f6d499f2041a01f0e2158b1976beae0b112c1412151fc4ae6476567fa57f9	8058072	\\xd24ba062e2494558717f1a4dff6131ea1cd2837c16e4c5586170d86a294740d8	2020-06-09 18:03:01.580135+00	2020-06-09 18:02:16+00
1255	\\x2f5d259268137591134cd138ec40aed621d78303dbdd1ea41c4210b99881bdd0	8058074	\\x6fc92b74a044efc4809688b27c22abb00fbd7c93bf7968220716ccf87b0cb469	2020-06-09 18:04:03.650472+00	2020-06-09 18:03:26+00
1257	\\x3f8b359d77a0fc88b3390690f2984714aceed2140dbd84f12db56119af5e1f1f	8058076	\\x5c9011c38f89dd18fbdf50c59878a7a480055b8d2d71b4bf146feb8256ee86cf	2020-06-09 18:04:17.00716+00	2020-06-09 18:04:06+00
1259	\\x65d843b94cc058dace93467b66f38cdbb366faa94d7aa8978e0b684bec7f5e8a	8058078	\\x97559048e8c3ef84c21981a1bb070e2ec298682b7c745828f429b851fc6bff86	2020-06-09 18:05:30.436082+00	2020-06-09 18:05:15+00
1261	\\xaba1544b8c3ab5d301bbda169e51e8d4ae1c8f709bac471855f58771afddf9d7	8058080	\\x4523f5d2c0b247c78bf2dc6c821d2ebfdedba091da531f9bf3d40fb635dc207e	2020-06-09 18:05:59.273074+00	2020-06-09 18:05:34+00
1263	\\xe9c0d9e9eb0557f4ef55ca2926f9325e1b1c56f6e0a3f9815ddd8bfb31b75434	8058082	\\x266a06fcaaf1e67797a34b56a95e2b9337fb245a820d87f8e82c7eced5198f76	2020-06-09 18:07:07.241441+00	2020-06-09 18:07:06+00
1265	\\x639f344a38ce446f247d344ccd6d2a05fd09708f055505bb9b94ee766758017a	8058084	\\x43d645b966d0ee751884537066ac3fab4ecd06a11c2f06e13555243e86342b6c	2020-06-09 18:07:52.736701+00	2020-06-09 18:07:10+00
1302	\\xbff79026ba3539a8c48734b216500e3594e313545b3ee2bda7cb4a9918b08fb4	8058119	\\x0c1d1570e547f8132c85b23c13e08131f3bdeefca746a4e63320875a5b992b47	2020-06-09 18:15:54.062793+00	2020-06-09 18:14:30+00
1303	\\xd97a9011f9c096c8dfe35adabfefbb61df85b7cb397538ca000fe4634c1096d3	8058120	\\xbff79026ba3539a8c48734b216500e3594e313545b3ee2bda7cb4a9918b08fb4	2020-06-09 18:15:54.06591+00	2020-06-09 18:15:35+00
1305	\\x0312381acacef36a13969c104fbbb4bb92346f728f67a6be7007b36c9b758adf	8058122	\\x71c7d700b9bc2ce30baa72efeca40302a95021bf0ffc48cf7b9da518c89d07b6	2020-06-09 18:16:27.193704+00	2020-06-09 18:16:15+00
1307	\\x943be1d045f8653635d03a3daccb29f27000a06eac87671d119335e581e36e0c	8058124	\\x8e16b1a351cd98ac1c5ac69b03e63996cf6a683c30a6aae2860ed2d63c0f2122	2020-06-09 18:17:09.69504+00	2020-06-09 18:17:04+00
1309	\\xe5730547d136f4d0862e82b18a6f870f7abcb086e8ee4c2fc0e3e12ad87fb313	8058126	\\x47139cc1b6302b92a4e545f257d7d60316c4c8f42a8f28781a34c122b1eac6c6	2020-06-09 18:18:44.29856+00	2020-06-09 18:17:24+00
1311	\\x2008cff4e78cd29b3337da70190ae33a3de465508903e6e5b512b95982067229	8058128	\\xaecb3d7b7aaaf4807545cd1dbd10f6234e1e59741024e52e04c14c2d36548239	2020-06-09 18:18:59.765989+00	2020-06-09 18:18:51+00
1246	\\x875afb955f2ffe6ab60ae8b7b46d8f48b79f8963bb5d8ffecdfb70d4aa9cbdb2	8058065	\\x41982acf0ec7a56021d8f78b1a8eb2feab62ce4636d7ca69579f1e213725713d	2020-06-09 18:01:13.024335+00	2020-06-09 18:00:46+00
1248	\\x06b38b870c7dd3c2f8679340cef96114efbda0002232ad6f378a27822d2ca3e4	8058067	\\xfd20ba75c5bcb514536bd6edff5e904b3b997bc681489373bd16864412028101	2020-06-09 18:01:31.895916+00	2020-06-09 18:01:22+00
1250	\\x87c684247f2ac635341187f1bef48a279584ccf28274abf0260ab6e2a0c1701a	8058069	\\x9e1e05b3fb091109b8b518f8589087387305892e5862e0ce769dcb8af4047862	2020-06-09 18:02:05.344433+00	2020-06-09 18:01:59+00
1313	\\xa12394e7b6ddb276a6d696c670d27bc5aeb4c2709efc81ab9ad981e84bb1501b	8058130	\\x0941755262d4067ed4b9691c1f62c03e123df661379bb57f1289aed62e8788a2	2020-06-09 18:19:19.315807+00	2020-06-09 18:19:12+00
1315	\\xa09ba23dd4c7382ccf5d32101e782b259f5a5f9c760cdd366fc832327a586aee	8058132	\\x54ff07b98d1e693689c8731d73e54ef067671e3fefb3111ba0df45de28dd2817	2020-06-09 18:19:48.624474+00	2020-06-09 18:19:31+00
1317	\\xc053b05e870440e92af1f03464166f526c54877b3f8500d552899d0b3b6d0ed2	8058134	\\x4f8d28e57a945bbe9abdc58bed2798658e5c7a44e892a5520c6b2977487d7e9b	2020-06-09 18:20:07.162174+00	2020-06-09 18:19:55+00
1319	\\x2cb2ef883e495510846a313e7fcb3254692d580f13dc6df338b8c1c7ce05fcd9	8058136	\\xb6082e369bae9c54a5bca6c3f36cad6060f61bad38492ca14e6d572faf9f5e1f	2020-06-09 18:20:23.529927+00	2020-06-09 18:20:22+00
1321	\\x852deb65b356a18fc8082d71c0c63f857856a95a51c858f1c90fe93d87e7e109	8058138	\\xaf285ea238600fa66efeda5c943f8e34e622990659bfa78adf162257838238d0	2020-06-09 18:20:59.287127+00	2020-06-09 18:20:26+00
1323	\\x2b4ce1fdf16bce74a031945f25d608dad7fb121eb252257ff4dae0f6fc7c6a19	8058140	\\xbdd09b85fdb385fbbd4c5fc5c177d142159a4a578e98110211b0c32748a430b3	2020-06-09 18:21:26.495505+00	2020-06-09 18:21:00+00
1325	\\x3677323c1ea963412acf29ad06ef8a66d478f92c36bd42f8bb015aee5a10f480	8058142	\\x4024696e54d88472a89b3df7de2ddf1e23fb9f804cb687082b4e507de871f50c	2020-06-09 18:22:08.836842+00	2020-06-09 18:22:00+00
1327	\\x346e781fa53cbb3b214130519929b7efe8357bcc2631fa36dcee49cea997960d	8058144	\\xdcb537858d62ec56ceebe309951e31b9a60e557440671e7379c2a2d9d2ee1924	2020-06-09 18:22:44.151584+00	2020-06-09 18:22:37+00
1329	\\xf1fc9aee8feba083aed30064c72942f2a06d3cd83af1a77567e800b85dde1923	8058146	\\xbf9f0f52615a7c232615c5852f44eca12259f4912b5a514fc636eab39954a6d9	2020-06-09 18:22:56.57175+00	2020-06-09 18:22:47+00
1331	\\x620c9ca12cf57b87c420a6c8adb798f248937f719908c4787420cc467c3b21b3	8058148	\\x1ab4f3ecce8ba480465340a9bd19423d5246054963cdfc45bd7d3bd127d2d259	2020-06-09 18:23:10.000147+00	2020-06-09 18:23:04+00
1333	\\xa04c95130c3bc3b75d74b2f1bfa525b8816fd709e8c0de1dafc8d52db3f1a3d3	8058150	\\xd92389e94bf4bb15628aa2c51271fce257f3cf83698826b4a6f506cebeec91e2	2020-06-09 18:23:24.800883+00	2020-06-09 18:23:11+00
1335	\\xbc8392386c3bac864baa19c15f3d206239ea5a9f00bff5fb16d9890b999a83de	8058152	\\x7cd85c61457299b0b67c189c7ffa1b33578b5c3db47dd8730105f8011bdcf87e	2020-06-09 18:23:48.661599+00	2020-06-09 18:23:38+00
1336	\\xe3847073f54b6ab5794c6f0d1d6e87a1db68568fddf8c5ab09847abe31b16a85	8058153	\\xbc8392386c3bac864baa19c15f3d206239ea5a9f00bff5fb16d9890b999a83de	2020-06-09 18:24:08.914205+00	2020-06-09 18:23:48+00
1338	\\x1d8e13986ada00abd055f539089a114b47f3e11ab1954f634efd9d9ee7b65458	8058155	\\xe45c933a031d5163a1a08e6d403995cee888fb1ee2f7c4503a47e2dd5b7d5d08	2020-06-09 18:24:56.133637+00	2020-06-09 18:24:19+00
1340	\\x37deff0770d1870887d6d6db642e05b2129332764c4e9ca890ee38996daabdb1	8058157	\\xdf82dfeacffbc156479beb5755aebd9e258701e74d1e52d9f2450765d1491dfe	2020-06-09 18:25:36.878445+00	2020-06-09 18:25:01+00
1342	\\xa29b9d1f4b5d3177f747ec91efe5bb4bf774b589f61f880bf75868f0a8db6226	8058159	\\x5c22b2a0711ec90ca13ca7ec8d42a1343fdac70e543d11180dacd74563c236d1	2020-06-09 18:25:51.42525+00	2020-06-09 18:25:44+00
1252	\\xd24ba062e2494558717f1a4dff6131ea1cd2837c16e4c5586170d86a294740d8	8058071	\\x6a32d2b47ae5d30d7e2b2e255968af13bdfb8c0b2b0ea35d15d1bdc072d50fdb	2020-06-09 18:02:17.050583+00	2020-06-09 18:02:02+00
1254	\\x6fc92b74a044efc4809688b27c22abb00fbd7c93bf7968220716ccf87b0cb469	8058073	\\xae0f6d499f2041a01f0e2158b1976beae0b112c1412151fc4ae6476567fa57f9	2020-06-09 18:03:26.384795+00	2020-06-09 18:03:01+00
1256	\\x5c9011c38f89dd18fbdf50c59878a7a480055b8d2d71b4bf146feb8256ee86cf	8058075	\\x2f5d259268137591134cd138ec40aed621d78303dbdd1ea41c4210b99881bdd0	2020-06-09 18:04:17.003315+00	2020-06-09 18:04:03+00
1258	\\x97559048e8c3ef84c21981a1bb070e2ec298682b7c745828f429b851fc6bff86	8058077	\\x3f8b359d77a0fc88b3390690f2984714aceed2140dbd84f12db56119af5e1f1f	2020-06-09 18:05:14.605003+00	2020-06-09 18:04:17+00
1260	\\x4523f5d2c0b247c78bf2dc6c821d2ebfdedba091da531f9bf3d40fb635dc207e	8058079	\\x65d843b94cc058dace93467b66f38cdbb366faa94d7aa8978e0b684bec7f5e8a	2020-06-09 18:05:35.466384+00	2020-06-09 18:05:29+00
1262	\\x266a06fcaaf1e67797a34b56a95e2b9337fb245a820d87f8e82c7eced5198f76	8058081	\\xaba1544b8c3ab5d301bbda169e51e8d4ae1c8f709bac471855f58771afddf9d7	2020-06-09 18:07:06.34369+00	2020-06-09 18:05:59+00
1264	\\x43d645b966d0ee751884537066ac3fab4ecd06a11c2f06e13555243e86342b6c	8058083	\\xe9c0d9e9eb0557f4ef55ca2926f9325e1b1c56f6e0a3f9815ddd8bfb31b75434	2020-06-09 18:07:12.200525+00	2020-06-09 18:07:07+00
1266	\\x7a0bd784e355bfc5e510afe7b49119249d3d5a4e1004067c6eaf8e5edb9ca9f6	8058085	\\x639f344a38ce446f247d344ccd6d2a05fd09708f055505bb9b94ee766758017a	2020-06-09 18:07:59.601729+00	2020-06-09 18:07:52+00
1344	\\xb47515dcdbf837c7b016430520a85d67c8f86a38c23a83f02fbd7e614b724661	8058161	\\xbed2f02661e114068f4c87b4ecc4bdcdcbcabca3d3c089cf11a0109d5099a9b0	2020-06-09 18:26:18.863321+00	2020-06-09 18:25:54+00
\.


--
-- Data for Name: initiators; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.initiators (id, job_spec_id, type, created_at, deleted_at, schedule, "time", ran, address, requesters, name, params, from_block, to_block, topics, request_data, feeds, threshold, "precision", polling_interval, absolute_threshold, updated_at, poll_timer, idle_timer) FROM stdin;
\.


--
-- Data for Name: job_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_runs (result_id, run_request_id, status, created_at, finished_at, updated_at, initiator_id, deleted_at, creation_height, observed_height, payment, job_spec_id, id) FROM stdin;
\.


--
-- Data for Name: job_specs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_specs (created_at, start_at, end_at, deleted_at, min_payment, id, updated_at) FROM stdin;
\.


--
-- Data for Name: keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keys (address, json, created_at, updated_at) FROM stdin;
\\xd8827d8d3640b128387c2e3206439e6aea1e8e3f	{"id": "c44bd647-2c04-429d-938e-484eb950880b", "crypto": {"kdf": "scrypt", "mac": "259ff1b8eb40a6664206a1fed3b704e91928851f9260b042f25e99f892d0c4e9", "cipher": "aes-128-ctr", "kdfparams": {"n": 262144, "p": 1, "r": 8, "salt": "6c933cd04633d9b4ebf7249d55eb3cda8e0a850243d6d4accc81cb5cd8dc8337", "dklen": 32}, "ciphertext": "3af227c464f4313316beb583d4e427491859d9fda113f74a0bb8ec828f30299f", "cipherparams": {"iv": "2a82ec497b5bedf5dc7194fb3f588d03"}}, "address": "d8827d8d3640b128387c2e3206439e6aea1e8e3f", "version": 3}	2020-06-09 13:50:15.036011+00	2020-06-09 13:50:15.036011+00
\.


--
-- Data for Name: log_consumptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_consumptions (id, block_hash, log_index, job_id, created_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id) FROM stdin;
0
1559081901
1559767166
1560433987
1560791143
1560881846
1560886530
1560924400
1560881855
1565139192
1564007745
1565210496
1566498796
1565877314
1566915476
1567029116
1568280052
1565291711
1568390387
1568833756
1570087128
1570675883
1573667511
1573812490
1575036327
1574659987
1576022702
1579700934
1580904019
1581240419
1584377646
1585908150
1585918589
1586163842
1586342453
1586369235
1586939705
1587027516
1587580235
1587591248
1587975059
1586956053
1588293486
1586949323
1588088353
1588757164
1588853064
1589470036
1586871710
1590226486
\.


--
-- Data for Name: run_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.run_requests (id, request_id, tx_hash, requester, created_at, block_hash, payment, request_params) FROM stdin;
\.


--
-- Data for Name: run_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.run_results (id, data, error_message, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: service_agreements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_agreements (id, created_at, encumbrance_id, request_body, signature, job_spec_id, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, last_used, created_at) FROM stdin;
\.


--
-- Data for Name: sync_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sync_events (id, created_at, updated_at, body) FROM stdin;
\.


--
-- Data for Name: task_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_runs (result_id, status, task_spec_id, minimum_confirmations, created_at, confirmations, job_run_id, id, updated_at) FROM stdin;
\.


--
-- Data for Name: task_specs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_specs (id, created_at, updated_at, deleted_at, type, confirmations, params, job_spec_id) FROM stdin;
\.


--
-- Data for Name: tx_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tx_attempts (id, tx_id, created_at, hash, gas_price, confirmed, sent_at, signed_raw_tx, updated_at) FROM stdin;
\.


--
-- Data for Name: txes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.txes (id, surrogate_id, "from", "to", data, nonce, value, gas_limit, hash, gas_price, confirmed, sent_at, signed_raw_tx, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (email, hashed_password, created_at, token_key, token_salt, token_hashed_secret, updated_at, token_secret) FROM stdin;
pratik@api.com	$2a$10$ceBJABnKkCsD5xT30MNHc.DoIfGN.Swmnqx3bpEkajrnewVD5bT7G	2020-06-09 13:50:15.033559+00				2020-06-09 13:50:15.03238+00	\N
\.


--
-- Name: configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configurations_id_seq', 1, false);


--
-- Name: encumbrances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.encumbrances_id_seq', 1, false);


--
-- Name: external_initiators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.external_initiators_id_seq', 1, false);


--
-- Name: heads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heads_id_seq', 1345, true);


--
-- Name: initiators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.initiators_id_seq', 1, false);


--
-- Name: log_consumptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_consumptions_id_seq', 1, false);


--
-- Name: run_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.run_requests_id_seq', 1, false);


--
-- Name: run_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.run_results_id_seq', 1, false);


--
-- Name: sync_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sync_events_id_seq', 1, false);


--
-- Name: task_specs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_specs_id_seq', 1, false);


--
-- Name: tx_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tx_attempts_id_seq', 1, false);


--
-- Name: txes_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.txes_id_seq1', 1, false);


--
-- Name: bridge_types bridge_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bridge_types
    ADD CONSTRAINT bridge_types_pkey PRIMARY KEY (name);


--
-- Name: configurations configurations_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_name_key UNIQUE (name);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: encrypted_secret_keys encrypted_secret_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encrypted_secret_keys
    ADD CONSTRAINT encrypted_secret_keys_pkey PRIMARY KEY (public_key);


--
-- Name: encumbrances encumbrances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encumbrances
    ADD CONSTRAINT encumbrances_pkey PRIMARY KEY (id);


--
-- Name: external_initiators external_initiators_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_initiators
    ADD CONSTRAINT external_initiators_name_key UNIQUE (name);


--
-- Name: external_initiators external_initiators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_initiators
    ADD CONSTRAINT external_initiators_pkey PRIMARY KEY (id);


--
-- Name: heads heads_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.heads
    ADD CONSTRAINT heads_pkey1 PRIMARY KEY (id);


--
-- Name: initiators initiators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initiators
    ADD CONSTRAINT initiators_pkey PRIMARY KEY (id);


--
-- Name: job_runs job_run_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT job_run_pkey PRIMARY KEY (id);


--
-- Name: job_specs job_spec_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_specs
    ADD CONSTRAINT job_spec_pkey PRIMARY KEY (id);


--
-- Name: keys keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT keys_pkey PRIMARY KEY (address);


--
-- Name: log_consumptions log_consumptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_consumptions
    ADD CONSTRAINT log_consumptions_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: run_requests run_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_requests
    ADD CONSTRAINT run_requests_pkey PRIMARY KEY (id);


--
-- Name: run_results run_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.run_results
    ADD CONSTRAINT run_results_pkey PRIMARY KEY (id);


--
-- Name: service_agreements service_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_agreements
    ADD CONSTRAINT service_agreements_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sync_events sync_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sync_events
    ADD CONSTRAINT sync_events_pkey PRIMARY KEY (id);


--
-- Name: task_runs task_run_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT task_run_pkey PRIMARY KEY (id);


--
-- Name: task_specs task_specs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_specs
    ADD CONSTRAINT task_specs_pkey PRIMARY KEY (id);


--
-- Name: tx_attempts tx_attempts_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tx_attempts
    ADD CONSTRAINT tx_attempts_pkey1 PRIMARY KEY (id);


--
-- Name: txes txes_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.txes
    ADD CONSTRAINT txes_pkey1 PRIMARY KEY (id);


--
-- Name: txes txes_surrogate_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.txes
    ADD CONSTRAINT txes_surrogate_id_key UNIQUE (surrogate_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (email);


--
-- Name: idx_bridge_types_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bridge_types_created_at ON public.bridge_types USING brin (created_at);


--
-- Name: idx_bridge_types_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bridge_types_updated_at ON public.bridge_types USING brin (updated_at);


--
-- Name: idx_configurations_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_configurations_name ON public.configurations USING btree (name);


--
-- Name: idx_encumbrances_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encumbrances_created_at ON public.encumbrances USING brin (created_at);


--
-- Name: idx_encumbrances_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encumbrances_updated_at ON public.encumbrances USING brin (updated_at);


--
-- Name: idx_external_initiators_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_external_initiators_deleted_at ON public.external_initiators USING btree (deleted_at);


--
-- Name: idx_heads_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_heads_hash ON public.heads USING btree (hash);


--
-- Name: idx_heads_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_heads_number ON public.heads USING btree (number);


--
-- Name: idx_initiators_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_address ON public.initiators USING btree (address);


--
-- Name: idx_initiators_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_created_at ON public.initiators USING btree (created_at);


--
-- Name: idx_initiators_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_deleted_at ON public.initiators USING btree (deleted_at);


--
-- Name: idx_initiators_job_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_job_spec_id ON public.initiators USING btree (job_spec_id);


--
-- Name: idx_initiators_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_type ON public.initiators USING btree (type);


--
-- Name: idx_initiators_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_initiators_updated_at ON public.initiators USING brin (updated_at);


--
-- Name: idx_job_runs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_created_at ON public.job_runs USING brin (created_at);


--
-- Name: idx_job_runs_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_deleted_at ON public.job_runs USING btree (deleted_at);


--
-- Name: idx_job_runs_finished_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_finished_at ON public.job_runs USING brin (finished_at);


--
-- Name: idx_job_runs_initiator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_initiator_id ON public.job_runs USING btree (initiator_id);


--
-- Name: idx_job_runs_job_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_job_spec_id ON public.job_runs USING btree (job_spec_id);


--
-- Name: idx_job_runs_result_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_result_id ON public.job_runs USING btree (result_id);


--
-- Name: idx_job_runs_run_request_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_run_request_id ON public.job_runs USING btree (run_request_id);


--
-- Name: idx_job_runs_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_status ON public.job_runs USING btree (status) WHERE (status <> 'completed'::public.run_status);


--
-- Name: idx_job_runs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_runs_updated_at ON public.job_runs USING brin (updated_at);


--
-- Name: idx_job_specs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_created_at ON public.job_specs USING btree (created_at);


--
-- Name: idx_job_specs_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_deleted_at ON public.job_specs USING btree (deleted_at);


--
-- Name: idx_job_specs_end_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_end_at ON public.job_specs USING btree (end_at);


--
-- Name: idx_job_specs_start_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_start_at ON public.job_specs USING btree (start_at);


--
-- Name: idx_job_specs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_specs_updated_at ON public.job_specs USING brin (updated_at);


--
-- Name: idx_run_requests_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_run_requests_created_at ON public.run_requests USING brin (created_at);


--
-- Name: idx_run_results_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_run_results_created_at ON public.run_results USING brin (created_at);


--
-- Name: idx_run_results_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_run_results_updated_at ON public.run_results USING brin (updated_at);


--
-- Name: idx_service_agreements_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_service_agreements_created_at ON public.service_agreements USING btree (created_at);


--
-- Name: idx_service_agreements_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_service_agreements_updated_at ON public.service_agreements USING brin (updated_at);


--
-- Name: idx_sessions_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sessions_created_at ON public.sessions USING brin (created_at);


--
-- Name: idx_sessions_last_used; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sessions_last_used ON public.sessions USING brin (last_used);


--
-- Name: idx_task_runs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_created_at ON public.task_runs USING brin (created_at);


--
-- Name: idx_task_runs_job_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_job_run_id ON public.task_runs USING btree (job_run_id);


--
-- Name: idx_task_runs_result_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_result_id ON public.task_runs USING btree (result_id);


--
-- Name: idx_task_runs_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_status ON public.task_runs USING btree (status) WHERE (status <> 'completed'::public.run_status);


--
-- Name: idx_task_runs_task_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_task_spec_id ON public.task_runs USING btree (task_spec_id);


--
-- Name: idx_task_runs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_runs_updated_at ON public.task_runs USING brin (updated_at);


--
-- Name: idx_task_specs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_created_at ON public.task_specs USING brin (created_at);


--
-- Name: idx_task_specs_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_deleted_at ON public.task_specs USING btree (deleted_at);


--
-- Name: idx_task_specs_job_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_job_spec_id ON public.task_specs USING btree (job_spec_id);


--
-- Name: idx_task_specs_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_type ON public.task_specs USING btree (type);


--
-- Name: idx_task_specs_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_specs_updated_at ON public.task_specs USING brin (updated_at);


--
-- Name: idx_tx_attempts_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_created_at ON public.tx_attempts USING brin (created_at);


--
-- Name: idx_tx_attempts_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_hash ON public.tx_attempts USING btree (hash);


--
-- Name: idx_tx_attempts_tx_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_tx_id ON public.tx_attempts USING btree (tx_id);


--
-- Name: idx_tx_attempts_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tx_attempts_updated_at ON public.tx_attempts USING brin (updated_at);


--
-- Name: idx_txes_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_created_at ON public.txes USING brin (created_at);


--
-- Name: idx_txes_from; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_from ON public.txes USING btree ("from");


--
-- Name: idx_txes_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_txes_hash ON public.txes USING btree (hash);


--
-- Name: idx_txes_surrogate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_surrogate_id ON public.txes USING btree (surrogate_id);


--
-- Name: idx_txes_unique_nonces_per_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_txes_unique_nonces_per_account ON public.txes USING btree (nonce, "from");


--
-- Name: idx_txes_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_txes_updated_at ON public.txes USING brin (updated_at);


--
-- Name: idx_users_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_created_at ON public.users USING btree (created_at);


--
-- Name: idx_users_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_updated_at ON public.users USING brin (updated_at);


--
-- Name: log_consumptions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX log_consumptions_created_at_idx ON public.log_consumptions USING brin (created_at);


--
-- Name: log_consumptions_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX log_consumptions_unique_idx ON public.log_consumptions USING btree (job_id, block_hash, log_index);


--
-- Name: sync_events_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sync_events_id_created_at_idx ON public.sync_events USING btree (id, created_at);


--
-- Name: initiators fk_initiators_job_spec_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initiators
    ADD CONSTRAINT fk_initiators_job_spec_id FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE RESTRICT;


--
-- Name: job_runs fk_job_runs_initiator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT fk_job_runs_initiator_id FOREIGN KEY (initiator_id) REFERENCES public.initiators(id) ON DELETE CASCADE;


--
-- Name: job_runs fk_job_runs_result_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT fk_job_runs_result_id FOREIGN KEY (result_id) REFERENCES public.run_results(id) ON DELETE CASCADE;


--
-- Name: job_runs fk_job_runs_run_request_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT fk_job_runs_run_request_id FOREIGN KEY (run_request_id) REFERENCES public.run_requests(id) ON DELETE CASCADE;


--
-- Name: service_agreements fk_service_agreements_encumbrance_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_agreements
    ADD CONSTRAINT fk_service_agreements_encumbrance_id FOREIGN KEY (encumbrance_id) REFERENCES public.encumbrances(id) ON DELETE RESTRICT;


--
-- Name: task_runs fk_task_runs_result_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT fk_task_runs_result_id FOREIGN KEY (result_id) REFERENCES public.run_results(id) ON DELETE CASCADE;


--
-- Name: task_runs fk_task_runs_task_spec_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT fk_task_runs_task_spec_id FOREIGN KEY (task_spec_id) REFERENCES public.task_specs(id) ON DELETE CASCADE;


--
-- Name: job_runs job_runs_job_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_runs
    ADD CONSTRAINT job_runs_job_spec_id_fkey FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: log_consumptions log_consumptions_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_consumptions
    ADD CONSTRAINT log_consumptions_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: service_agreements service_agreements_job_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_agreements
    ADD CONSTRAINT service_agreements_job_spec_id_fkey FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: task_runs task_runs_job_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_runs
    ADD CONSTRAINT task_runs_job_run_id_fkey FOREIGN KEY (job_run_id) REFERENCES public.job_runs(id) ON DELETE CASCADE;


--
-- Name: task_specs task_specs_job_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_specs
    ADD CONSTRAINT task_specs_job_spec_id_fkey FOREIGN KEY (job_spec_id) REFERENCES public.job_specs(id) ON DELETE CASCADE;


--
-- Name: tx_attempts tx_attempts_tx_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tx_attempts
    ADD CONSTRAINT tx_attempts_tx_id_fkey FOREIGN KEY (tx_id) REFERENCES public.txes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

