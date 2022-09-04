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
-- Name: core; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA core;


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: App_appID_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core."App_appID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

--
-- Name: App; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core."App" (
    "appID" bigint DEFAULT nextval('core."App_appID_seq"'::regclass) NOT NULL,
    name text NOT NULL,
    description text,
    lang text,
    "authorID" bigint,
    "pageURL" text NOT NULL,
    "byteSize" bigint NOT NULL,
    "iconURL" text NOT NULL,
    "colorBg" character(7),
    "colorTheme" character(7),
    screenshots text[],
    tsv_search tsvector,
    promoted boolean DEFAULT false NOT NULL
);


--
-- Name: App_authorID_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core."App_authorID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: App_authorID_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core."App_authorID_seq" OWNED BY core."App"."authorID";


--
-- Name: Author; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core."Author" (
    "authorID" bigint NOT NULL,
    name text NOT NULL,
    "customConfig" json
);


--
-- Name: Author_authorID_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core."Author_authorID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Author_authorID_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core."Author_authorID_seq" OWNED BY core."Author"."authorID";


--
-- Name: Review; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core."Review" (
    "reviewID" bigint NOT NULL,
    "appID" bigint NOT NULL,
    ip text NOT NULL,
    rating smallint NOT NULL,
    body text,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT valid_rating CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: Review_appID_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core."Review_appID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Review_appID_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core."Review_appID_seq" OWNED BY core."Review"."appID";


--
-- Name: Review_reviewID_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core."Review_reviewID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Review_reviewID_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core."Review_reviewID_seq" OWNED BY core."Review"."reviewID";


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: App authorID; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."App" ALTER COLUMN "authorID" SET DEFAULT nextval('core."App_authorID_seq"'::regclass);


--
-- Name: Author authorID; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."Author" ALTER COLUMN "authorID" SET DEFAULT nextval('core."Author_authorID_seq"'::regclass);


--
-- Name: Review reviewID; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."Review" ALTER COLUMN "reviewID" SET DEFAULT nextval('core."Review_reviewID_seq"'::regclass);


--
-- Name: Review appID; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."Review" ALTER COLUMN "appID" SET DEFAULT nextval('core."Review_appID_seq"'::regclass);


--
-- Name: Author Author_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."Author"
    ADD CONSTRAINT "Author_pkey" PRIMARY KEY ("authorID");


--
-- Name: Review Review_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."Review"
    ADD CONSTRAINT "Review_pkey" PRIMARY KEY ("reviewID");


--
-- Name: App appID_PK; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."App"
    ADD CONSTRAINT "appID_PK" PRIMARY KEY ("appID");


--
-- Name: App pageURL_UNQ; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."App"
    ADD CONSTRAINT "pageURL_UNQ" UNIQUE ("pageURL");


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tsv_search_idx; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX tsv_search_idx ON core."App" USING gin (tsv_search);


--
-- Name: Review appID_fk; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."Review"
    ADD CONSTRAINT "appID_fk" FOREIGN KEY ("appID") REFERENCES core."App"("appID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: App authorID_FK; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core."App"
    ADD CONSTRAINT "authorID_FK" FOREIGN KEY ("authorID") REFERENCES core."Author"("authorID") NOT VALID;


--
-- PostgreSQL database dump complete
--

SET search_path TO public,core;



