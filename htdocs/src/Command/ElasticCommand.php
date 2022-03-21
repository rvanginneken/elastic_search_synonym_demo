<?php

namespace App\Command;

use Elasticsearch\Client;
use Elasticsearch\ClientBuilder;
use Elasticsearch\Common\Exceptions\Missing404Exception;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class ElasticCommand extends Command
{
    private const INDEX = 'movies';
    private const BULK_SIZE = 250;

    protected static $defaultName = 'app:elastic';
    protected static $defaultDescription = 'Add a short description for your command';

    private ?Client $client;
    private array $body = [];

    protected function configure(): void
    {
        $this
            ->addArgument('arg1', InputArgument::OPTIONAL, 'Argument description')
            ->addOption('option1', null, InputOption::VALUE_NONE, 'Option description')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $this->createIndex();
        $this->insertData();

        return Command::SUCCESS;
    }

    private function createIndex(): void
    {
        try {
            $this->getClient()->indices()->delete(['index' => self::INDEX]);
        } catch (Missing404Exception $e) {
            // nothing to delete
        }

        $this->getClient()->indices()->create([
            'index' => self::INDEX,
            'include_type_name' => false,
            'body' => [
                'settings' => [
                    'number_of_shards' => 1,
                    'number_of_replicas' => 0,
                    'analysis' => [
                        'analyzer' => [
                            // default and default_search are keywords that make them get used by default: https://www.elastic.co/guide/en/elasticsearch/reference/current/analyzer.html#analyzer
                            'default' => [ // used on index time when not field analyzer is set
                                'type' => 'custom',
                                'tokenizer' => 'standard',
                                'filter' => ['lowercase', 'asciifolding'],
                            ],
                            'default_search' => [ // used on query time when not field analyzer is set or send with the query
                                'type' => 'custom',
                                'tokenizer' => 'standard',
                                'filter' => ['lowercase', 'asciifolding'],
                            ],
                        ],

                    ],
                ],
            ],
        ]);
    }

    private function insertData(): void
    {
        $data = json_decode(file_get_contents('/vagrant/htdocs/resources/movies.json'), true, 512, JSON_THROW_ON_ERROR);
        foreach ($data as $record) {
            $this->body[] = [
                'index' => [
                    '_index' => self::INDEX,
                ],
            ];

            $this->body[] = $record;

            $this->commit();
        }
        $this->commit(true);
    }

    private function commit(bool $force = false): void
    {
        $docCount = \count($this->body);
        if ($docCount > 0 && ($force || $docCount > self::BULK_SIZE)) {
            try {
                $this->getClient()->bulk(['body' => $this->body]);
            } catch (\Exception $e) {
            }
            $this->body = [];
        }
    }

    private function getClient(): Client
    {
        return $this->client ??= ClientBuilder::create()->build();
    }
}
